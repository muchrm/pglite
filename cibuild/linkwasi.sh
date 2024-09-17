#!/bin/bash
. /opt/python-wasm-sdk/wasisdk/wasisdk_env.sh
# dlfcn emulation

WASI_CFLAGS="-DPATCH_PG_DEBUG=/tmp/pglite/include/pg_debug.h -DPREFIX=/tmp/pglite -DPYDK=1" wasi-c -fPIC \
 -Ipostgresql/src/include \
 -Ipostgresql/src/backend \
 -c -o build/postgres/wasi_dlfcn.o \
 -Ibuild/postgres/src/include patches/wasi_dlfcn.c || exit 8
#  -L./build/postgres/src/backend/snowball -ldict_snowball
# ./build/postgres/src/backend/snowball/dict_snowball.o
# ./build/postgres/src/backend/snowball/libdict_snowball.a

# just linking

pushd build/postgres/src/backend
$CC -o postgres \
 -Wall \
 -Wmissing-prototypes \
 -Wpointer-arith \
 -Wdeclaration-after-statement \
 -Werror=vla \
 -Werror=unguarded-availability-new \
 -Wendif-labels \
 -Wmissing-format-attribute \
 -Wcast-function-type \
 -Wformat-security \
 -fno-strict-aliasing \
 -fwrapv \
 -fexcess-precision=standard \
 -Wno-unused-command-line-argument \
 -Wno-compound-token-split-by-macro \
 -Wno-format-truncation \
 -Wno-cast-function-type-strict \
 -O2 \
 access/brin/brin.o \
 access/brin/brin_bloom.o \
 access/brin/brin_inclusion.o \
 access/brin/brin_minmax.o \
 access/brin/brin_minmax_multi.o \
 access/brin/brin_pageops.o \
 access/brin/brin_revmap.o \
 access/brin/brin_tuple.o \
 access/brin/brin_validate.o \
 access/brin/brin_xlog.o \
 access/common/attmap.o \
 access/common/bufmask.o \
 access/common/detoast.o \
 access/common/heaptuple.o \
 access/common/indextuple.o \
 access/common/printsimple.o \
 access/common/printtup.o \
 access/common/relation.o \
 access/common/reloptions.o \
 access/common/scankey.o \
 access/common/session.o \
 access/common/syncscan.o \
 access/common/toast_compression.o \
 access/common/toast_internals.o \
 access/common/tupconvert.o \
 access/common/tupdesc.o \
 access/gin/ginarrayproc.o \
 access/gin/ginbtree.o \
 access/gin/ginbulk.o \
 access/gin/gindatapage.o \
 access/gin/ginentrypage.o \
 access/gin/ginfast.o \
 access/gin/ginget.o \
 access/gin/gininsert.o \
 access/gin/ginlogic.o \
 access/gin/ginpostinglist.o \
 access/gin/ginscan.o \
 access/gin/ginutil.o \
 access/gin/ginvacuum.o \
 access/gin/ginvalidate.o \
 access/gin/ginxlog.o \
 access/gist/gist.o \
 access/gist/gistbuild.o \
 access/gist/gistbuildbuffers.o \
 access/gist/gistget.o \
 access/gist/gistproc.o \
 access/gist/gistscan.o \
 access/gist/gistsplit.o \
 access/gist/gistutil.o \
 access/gist/gistvacuum.o \
 access/gist/gistvalidate.o \
 access/gist/gistxlog.o \
 access/hash/hash.o \
 access/hash/hash_xlog.o \
 access/hash/hashfunc.o \
 access/hash/hashinsert.o \
 access/hash/hashovfl.o \
 access/hash/hashpage.o \
 access/hash/hashsearch.o \
 access/hash/hashsort.o \
 access/hash/hashutil.o \
 access/hash/hashvalidate.o \
 access/heap/heapam.o \
 access/heap/heapam_handler.o \
 access/heap/heapam_visibility.o \
 access/heap/heaptoast.o \
 access/heap/hio.o \
 access/heap/pruneheap.o \
 access/heap/rewriteheap.o \
 access/heap/vacuumlazy.o \
 access/heap/visibilitymap.o \
 access/index/amapi.o \
 access/index/amvalidate.o \
 access/index/genam.o \
 access/index/indexam.o \
 access/nbtree/nbtcompare.o \
 access/nbtree/nbtdedup.o \
 access/nbtree/nbtinsert.o \
 access/nbtree/nbtpage.o \
 access/nbtree/nbtree.o \
 access/nbtree/nbtsearch.o \
 access/nbtree/nbtsort.o \
 access/nbtree/nbtsplitloc.o \
 access/nbtree/nbtutils.o \
 access/nbtree/nbtvalidate.o \
 access/nbtree/nbtxlog.o \
 access/rmgrdesc/brindesc.o \
 access/rmgrdesc/clogdesc.o \
 access/rmgrdesc/committsdesc.o \
 access/rmgrdesc/dbasedesc.o \
 access/rmgrdesc/genericdesc.o \
 access/rmgrdesc/gindesc.o \
 access/rmgrdesc/gistdesc.o \
 access/rmgrdesc/hashdesc.o \
 access/rmgrdesc/heapdesc.o \
 access/rmgrdesc/logicalmsgdesc.o \
 access/rmgrdesc/mxactdesc.o \
 access/rmgrdesc/nbtdesc.o \
 access/rmgrdesc/relmapdesc.o \
 access/rmgrdesc/replorigindesc.o \
 access/rmgrdesc/rmgrdesc_utils.o \
 access/rmgrdesc/seqdesc.o \
 access/rmgrdesc/smgrdesc.o \
 access/rmgrdesc/spgdesc.o \
 access/rmgrdesc/standbydesc.o \
 access/rmgrdesc/tblspcdesc.o \
 access/rmgrdesc/xactdesc.o \
 access/rmgrdesc/xlogdesc.o \
 access/spgist/spgdoinsert.o \
 access/spgist/spginsert.o \
 access/spgist/spgkdtreeproc.o \
 access/spgist/spgproc.o \
 access/spgist/spgquadtreeproc.o \
 access/spgist/spgscan.o \
 access/spgist/spgtextproc.o \
 access/spgist/spgutils.o \
 access/spgist/spgvacuum.o \
 access/spgist/spgvalidate.o \
 access/spgist/spgxlog.o \
 access/table/table.o \
 access/table/tableam.o \
 access/table/tableamapi.o \
 access/table/toast_helper.o \
 access/tablesample/bernoulli.o \
 access/tablesample/system.o \
 access/tablesample/tablesample.o \
 access/transam/clog.o \
 access/transam/commit_ts.o \
 access/transam/generic_xlog.o \
 access/transam/multixact.o \
 access/transam/parallel.o \
 access/transam/rmgr.o \
 access/transam/slru.o \
 access/transam/subtrans.o \
 access/transam/timeline.o \
 access/transam/transam.o \
 access/transam/twophase.o \
 access/transam/twophase_rmgr.o \
 access/transam/varsup.o \
 access/transam/xact.o \
 access/transam/xlog.o \
 access/transam/xlogarchive.o \
 access/transam/xlogbackup.o \
 access/transam/xlogfuncs.o \
 access/transam/xloginsert.o \
 access/transam/xlogprefetcher.o \
 access/transam/xlogreader.o \
 access/transam/xlogrecovery.o \
 access/transam/xlogstats.o \
 access/transam/xlogutils.o \
 archive/shell_archive.o \
 backup/backup_manifest.o \
 backup/basebackup.o \
 backup/basebackup_copy.o \
 backup/basebackup_gzip.o \
 backup/basebackup_lz4.o \
 backup/basebackup_zstd.o \
 backup/basebackup_progress.o \
 backup/basebackup_server.o \
 backup/basebackup_sink.o \
 backup/basebackup_target.o \
 backup/basebackup_throttle.o \
 bootstrap/bootparse.o \
 bootstrap/bootscanner.o \
 bootstrap/bootstrap.o \
 catalog/aclchk.o \
 catalog/catalog.o \
 catalog/dependency.o \
 catalog/heap.o \
 catalog/index.o \
 catalog/indexing.o \
 catalog/namespace.o \
 catalog/objectaccess.o \
 catalog/objectaddress.o \
 catalog/partition.o \
 catalog/pg_aggregate.o \
 catalog/pg_attrdef.o \
 catalog/pg_cast.o \
 catalog/pg_class.o \
 catalog/pg_collation.o \
 catalog/pg_constraint.o \
 catalog/pg_conversion.o \
 catalog/pg_db_role_setting.o \
 catalog/pg_depend.o \
 catalog/pg_enum.o \
 catalog/pg_inherits.o \
 catalog/pg_largeobject.o \
 catalog/pg_namespace.o \
 catalog/pg_operator.o \
 catalog/pg_parameter_acl.o \
 catalog/pg_proc.o \
 catalog/pg_publication.o \
 catalog/pg_range.o \
 catalog/pg_shdepend.o \
 catalog/pg_subscription.o \
 catalog/pg_type.o \
 catalog/storage.o \
 catalog/toasting.o \
 parser/analyze.o \
 parser/gram.o \
 parser/parse_agg.o \
 parser/parse_clause.o \
 parser/parse_coerce.o \
 parser/parse_collate.o \
 parser/parse_cte.o \
 parser/parse_enr.o \
 parser/parse_expr.o \
 parser/parse_func.o \
 parser/parse_merge.o \
 parser/parse_node.o \
 parser/parse_oper.o \
 parser/parse_param.o \
 parser/parse_relation.o \
 parser/parse_target.o \
 parser/parse_type.o \
 parser/parse_utilcmd.o \
 parser/parser.o \
 parser/scan.o \
 parser/scansup.o \
 commands/aggregatecmds.o \
 commands/alter.o \
 commands/amcmds.o \
 commands/analyze.o \
 commands/async.o \
 commands/cluster.o \
 commands/collationcmds.o \
 commands/comment.o \
 commands/constraint.o \
 commands/conversioncmds.o \
 commands/copy.o \
 commands/copyfrom.o \
 commands/copyfromparse.o \
 commands/copyto.o \
 commands/createas.o \
 commands/dbcommands.o \
 commands/define.o \
 commands/discard.o \
 commands/dropcmds.o \
 commands/event_trigger.o \
 commands/explain.o \
 commands/extension.o \
 commands/foreigncmds.o \
 commands/functioncmds.o \
 commands/indexcmds.o \
 commands/lockcmds.o \
 commands/matview.o \
 commands/opclasscmds.o \
 commands/operatorcmds.o \
 commands/policy.o \
 commands/portalcmds.o \
 commands/prepare.o \
 commands/proclang.o \
 commands/publicationcmds.o \
 commands/schemacmds.o \
 commands/seclabel.o \
 commands/sequence.o \
 commands/statscmds.o \
 commands/subscriptioncmds.o \
 commands/tablecmds.o \
 commands/tablespace.o \
 commands/trigger.o \
 commands/tsearchcmds.o \
 commands/typecmds.o \
 commands/user.o \
 commands/vacuum.o \
 commands/vacuumparallel.o \
 commands/variable.o \
 commands/view.o \
 executor/execAmi.o \
 executor/execAsync.o \
 executor/execCurrent.o \
 executor/execExpr.o \
 executor/execExprInterp.o \
 executor/execGrouping.o \
 executor/execIndexing.o \
 executor/execJunk.o \
 executor/execMain.o \
 executor/execParallel.o \
 executor/execPartition.o \
 executor/execProcnode.o \
 executor/execReplication.o \
 executor/execSRF.o \
 executor/execScan.o \
 executor/execTuples.o \
 executor/execUtils.o \
 executor/functions.o \
 executor/instrument.o \
 executor/nodeAgg.o \
 executor/nodeAppend.o \
 executor/nodeBitmapAnd.o \
 executor/nodeBitmapHeapscan.o \
 executor/nodeBitmapIndexscan.o \
 executor/nodeBitmapOr.o \
 executor/nodeCtescan.o \
 executor/nodeCustom.o \
 executor/nodeForeignscan.o \
 executor/nodeFunctionscan.o \
 executor/nodeGather.o \
 executor/nodeGatherMerge.o \
 executor/nodeGroup.o \
 executor/nodeHash.o \
 executor/nodeHashjoin.o \
 executor/nodeIncrementalSort.o \
 executor/nodeIndexonlyscan.o \
 executor/nodeIndexscan.o \
 executor/nodeLimit.o \
 executor/nodeLockRows.o \
 executor/nodeMaterial.o \
 executor/nodeMemoize.o \
 executor/nodeMergeAppend.o \
 executor/nodeMergejoin.o \
 executor/nodeModifyTable.o \
 executor/nodeNamedtuplestorescan.o \
 executor/nodeNestloop.o \
 executor/nodeProjectSet.o \
 executor/nodeRecursiveunion.o \
 executor/nodeResult.o \
 executor/nodeSamplescan.o \
 executor/nodeSeqscan.o \
 executor/nodeSetOp.o \
 executor/nodeSort.o \
 executor/nodeSubplan.o \
 executor/nodeSubqueryscan.o \
 executor/nodeTableFuncscan.o \
 executor/nodeTidrangescan.o \
 executor/nodeTidscan.o \
 executor/nodeUnique.o \
 executor/nodeValuesscan.o \
 executor/nodeWindowAgg.o \
 executor/nodeWorktablescan.o \
 executor/spi.o \
 executor/tqueue.o \
 executor/tstoreReceiver.o \
 foreign/foreign.o \
 lib/binaryheap.o \
 lib/bipartite_match.o \
 lib/bloomfilter.o \
 lib/dshash.o \
 lib/hyperloglog.o \
 lib/ilist.o \
 lib/integerset.o \
 lib/knapsack.o \
 lib/pairingheap.o \
 lib/rbtree.o \
 libpq/auth-sasl.o \
 libpq/auth-scram.o \
 libpq/auth.o \
 libpq/be-fsstubs.o \
 libpq/be-secure-common.o \
 libpq/be-secure.o \
 libpq/crypt.o \
 libpq/hba.o \
 libpq/ifaddr.o \
 libpq/pqcomm.o \
 libpq/pqformat.o \
 libpq/pqmq.o \
 libpq/pqsignal.o \
 main/main.o \
 nodes/bitmapset.o \
 nodes/copyfuncs.o \
 nodes/equalfuncs.o \
 nodes/extensible.o \
 nodes/list.o \
 nodes/makefuncs.o \
 nodes/multibitmapset.o \
 nodes/nodeFuncs.o \
 nodes/nodes.o \
 nodes/outfuncs.o \
 nodes/params.o \
 nodes/print.o \
 nodes/queryjumblefuncs.o \
 nodes/read.o \
 nodes/readfuncs.o \
 nodes/tidbitmap.o \
 nodes/value.o \
 optimizer/geqo/geqo_copy.o \
 optimizer/geqo/geqo_cx.o \
 optimizer/geqo/geqo_erx.o \
 optimizer/geqo/geqo_eval.o \
 optimizer/geqo/geqo_main.o \
 optimizer/geqo/geqo_misc.o \
 optimizer/geqo/geqo_mutation.o \
 optimizer/geqo/geqo_ox1.o \
 optimizer/geqo/geqo_ox2.o \
 optimizer/geqo/geqo_pmx.o \
 optimizer/geqo/geqo_pool.o \
 optimizer/geqo/geqo_px.o \
 optimizer/geqo/geqo_random.o \
 optimizer/geqo/geqo_recombination.o \
 optimizer/geqo/geqo_selection.o \
 optimizer/path/allpaths.o \
 optimizer/path/clausesel.o \
 optimizer/path/costsize.o \
 optimizer/path/equivclass.o \
 optimizer/path/indxpath.o \
 optimizer/path/joinpath.o \
 optimizer/path/joinrels.o \
 optimizer/path/pathkeys.o \
 optimizer/path/tidpath.o \
 optimizer/plan/analyzejoins.o \
 optimizer/plan/createplan.o \
 optimizer/plan/initsplan.o \
 optimizer/plan/planagg.o \
 optimizer/plan/planmain.o \
 optimizer/plan/planner.o \
 optimizer/plan/setrefs.o \
 optimizer/plan/subselect.o \
 optimizer/prep/prepagg.o \
 optimizer/prep/prepjointree.o \
 optimizer/prep/prepqual.o \
 optimizer/prep/preptlist.o \
 optimizer/prep/prepunion.o \
 optimizer/util/appendinfo.o \
 optimizer/util/clauses.o \
 optimizer/util/inherit.o \
 optimizer/util/joininfo.o \
 optimizer/util/orclauses.o \
 optimizer/util/paramassign.o \
 optimizer/util/pathnode.o \
 optimizer/util/placeholder.o \
 optimizer/util/plancat.o \
 optimizer/util/predtest.o \
 optimizer/util/relnode.o \
 optimizer/util/restrictinfo.o \
 optimizer/util/tlist.o \
 optimizer/util/var.o \
 partitioning/partbounds.o \
 partitioning/partdesc.o \
 partitioning/partprune.o \
 port/atomics.o \
 port/pg_sema.o \
 port/pg_shmem.o \
 postmaster/autovacuum.o \
 postmaster/auxprocess.o \
 postmaster/bgworker.o \
 postmaster/bgwriter.o \
 postmaster/checkpointer.o \
 postmaster/fork_process.o \
 postmaster/interrupt.o \
 postmaster/pgarch.o \
 postmaster/postmaster.o \
 postmaster/startup.o \
 postmaster/syslogger.o \
 postmaster/walwriter.o \
 regex/regcomp.o \
 regex/regerror.o \
 regex/regexec.o \
 regex/regexport.o \
 regex/regfree.o \
 regex/regprefix.o \
 replication/logical/applyparallelworker.o \
 replication/logical/decode.o \
 replication/logical/launcher.o \
 replication/logical/logical.o \
 replication/logical/logicalfuncs.o \
 replication/logical/message.o \
 replication/logical/origin.o \
 replication/logical/proto.o \
 replication/logical/relation.o \
 replication/logical/reorderbuffer.o \
 replication/logical/snapbuild.o \
 replication/logical/tablesync.o \
 replication/logical/worker.o \
 replication/repl_gram.o \
 replication/repl_scanner.o \
 replication/slot.o \
 replication/slotfuncs.o \
 replication/syncrep.o \
 replication/syncrep_gram.o \
 replication/syncrep_scanner.o \
 replication/walreceiver.o \
 replication/walreceiverfuncs.o \
 replication/walsender.o \
 rewrite/rewriteDefine.o \
 rewrite/rewriteHandler.o \
 rewrite/rewriteManip.o \
 rewrite/rewriteRemove.o \
 rewrite/rewriteSearchCycle.o \
 rewrite/rewriteSupport.o \
 rewrite/rowsecurity.o \
 statistics/dependencies.o \
 statistics/extended_stats.o \
 statistics/mcv.o \
 statistics/mvdistinct.o \
 storage/buffer/buf_init.o \
 storage/buffer/buf_table.o \
 storage/buffer/bufmgr.o \
 storage/buffer/freelist.o \
 storage/buffer/localbuf.o \
 storage/file/buffile.o \
 storage/file/copydir.o \
 storage/file/fd.o \
 storage/file/fileset.o \
 storage/file/reinit.o \
 storage/file/sharedfileset.o \
 storage/freespace/freespace.o \
 storage/freespace/fsmpage.o \
 storage/freespace/indexfsm.o \
 storage/ipc/barrier.o \
 storage/ipc/dsm.o \
 storage/ipc/dsm_impl.o \
 storage/ipc/ipc.o \
 storage/ipc/ipci.o \
 storage/ipc/latch.o \
 storage/ipc/pmsignal.o \
 storage/ipc/procarray.o \
 storage/ipc/procsignal.o \
 storage/ipc/shm_mq.o \
 storage/ipc/shm_toc.o \
 storage/ipc/shmem.o \
 storage/ipc/signalfuncs.o \
 storage/ipc/sinval.o \
 storage/ipc/sinvaladt.o \
 storage/ipc/standby.o \
 storage/large_object/inv_api.o \
 storage/lmgr/condition_variable.o \
 storage/lmgr/deadlock.o \
 storage/lmgr/lmgr.o \
 storage/lmgr/lock.o \
 storage/lmgr/lwlock.o \
 storage/lmgr/lwlocknames.o \
 storage/lmgr/predicate.o \
 storage/lmgr/proc.o \
 storage/lmgr/s_lock.o \
 storage/lmgr/spin.o \
 storage/page/bufpage.o \
 storage/page/checksum.o \
 storage/page/itemptr.o \
 storage/smgr/md.o \
 storage/smgr/smgr.o \
 storage/sync/sync.o \
 tcop/cmdtag.o \
 tcop/dest.o \
 tcop/fastpath.o \
 tcop/postgres.o \
 tcop/pquery.o \
 tcop/utility.o \
 tsearch/dict.o \
 tsearch/dict_ispell.o \
 tsearch/dict_simple.o \
 tsearch/dict_synonym.o \
 tsearch/dict_thesaurus.o \
 tsearch/regis.o \
 tsearch/spell.o \
 tsearch/to_tsany.o \
 tsearch/ts_locale.o \
 tsearch/ts_parse.o \
 tsearch/ts_selfuncs.o \
 tsearch/ts_typanalyze.o \
 tsearch/ts_utils.o \
 tsearch/wparser.o \
 tsearch/wparser_def.o \
 utils/activity/backend_progress.o \
 utils/activity/backend_status.o \
 utils/activity/pgstat.o \
 utils/activity/pgstat_archiver.o \
 utils/activity/pgstat_bgwriter.o \
 utils/activity/pgstat_checkpointer.o \
 utils/activity/pgstat_database.o \
 utils/activity/pgstat_function.o \
 utils/activity/pgstat_io.o \
 utils/activity/pgstat_relation.o \
 utils/activity/pgstat_replslot.o \
 utils/activity/pgstat_shmem.o \
 utils/activity/pgstat_slru.o \
 utils/activity/pgstat_subscription.o \
 utils/activity/pgstat_wal.o \
 utils/activity/pgstat_xact.o \
 utils/activity/wait_event.o \
 utils/adt/acl.o \
 utils/adt/amutils.o \
 utils/adt/array_expanded.o \
 utils/adt/array_selfuncs.o \
 utils/adt/array_typanalyze.o \
 utils/adt/array_userfuncs.o \
 utils/adt/arrayfuncs.o \
 utils/adt/arraysubs.o \
 utils/adt/arrayutils.o \
 utils/adt/ascii.o \
 utils/adt/bool.o \
 utils/adt/cash.o \
 utils/adt/char.o \
 utils/adt/cryptohashfuncs.o \
 utils/adt/date.o \
 utils/adt/datetime.o \
 utils/adt/datum.o \
 utils/adt/dbsize.o \
 utils/adt/domains.o \
 utils/adt/encode.o \
 utils/adt/enum.o \
 utils/adt/expandeddatum.o \
 utils/adt/expandedrecord.o \
 utils/adt/float.o \
 utils/adt/format_type.o \
 utils/adt/formatting.o \
 utils/adt/genfile.o \
 utils/adt/geo_ops.o \
 utils/adt/geo_selfuncs.o \
 utils/adt/geo_spgist.o \
 utils/adt/hbafuncs.o \
 utils/adt/inet_cidr_ntop.o \
 utils/adt/inet_net_pton.o \
 utils/adt/int.o \
 utils/adt/int8.o \
 utils/adt/json.o \
 utils/adt/jsonb.o \
 utils/adt/jsonb_gin.o \
 utils/adt/jsonb_op.o \
 utils/adt/jsonb_util.o \
 utils/adt/jsonfuncs.o \
 utils/adt/jsonbsubs.o \
 utils/adt/jsonpath.o \
 utils/adt/jsonpath_exec.o \
 utils/adt/jsonpath_gram.o \
 utils/adt/jsonpath_scan.o \
 utils/adt/like.o \
 utils/adt/like_support.o \
 utils/adt/lockfuncs.o \
 utils/adt/mac.o \
 utils/adt/mac8.o \
 utils/adt/mcxtfuncs.o \
 utils/adt/misc.o \
 utils/adt/multirangetypes.o \
 utils/adt/multirangetypes_selfuncs.o \
 utils/adt/name.o \
 utils/adt/network.o \
 utils/adt/network_gist.o \
 utils/adt/network_selfuncs.o \
 utils/adt/network_spgist.o \
 utils/adt/numeric.o \
 utils/adt/numutils.o \
 utils/adt/oid.o \
 utils/adt/oracle_compat.o \
 utils/adt/orderedsetaggs.o \
 utils/adt/partitionfuncs.o \
 utils/adt/pg_locale.o \
 utils/adt/pg_lsn.o \
 utils/adt/pg_upgrade_support.o \
 utils/adt/pgstatfuncs.o \
 utils/adt/pseudotypes.o \
 utils/adt/quote.o \
 utils/adt/rangetypes.o \
 utils/adt/rangetypes_gist.o \
 utils/adt/rangetypes_selfuncs.o \
 utils/adt/rangetypes_spgist.o \
 utils/adt/rangetypes_typanalyze.o \
 utils/adt/regexp.o \
 utils/adt/regproc.o \
 utils/adt/ri_triggers.o \
 utils/adt/rowtypes.o \
 utils/adt/ruleutils.o \
 utils/adt/selfuncs.o \
 utils/adt/tid.o \
 utils/adt/timestamp.o \
 utils/adt/trigfuncs.o \
 utils/adt/tsginidx.o \
 utils/adt/tsgistidx.o \
 utils/adt/tsquery.o \
 utils/adt/tsquery_cleanup.o \
 utils/adt/tsquery_gist.o \
 utils/adt/tsquery_op.o \
 utils/adt/tsquery_rewrite.o \
 utils/adt/tsquery_util.o \
 utils/adt/tsrank.o \
 utils/adt/tsvector.o \
 utils/adt/tsvector_op.o \
 utils/adt/tsvector_parser.o \
 utils/adt/uuid.o \
 utils/adt/varbit.o \
 utils/adt/varchar.o \
 utils/adt/varlena.o \
 utils/adt/version.o \
 utils/adt/windowfuncs.o \
 utils/adt/xid.o \
 utils/adt/xid8funcs.o \
 utils/adt/xml.o \
 utils/cache/attoptcache.o \
 utils/cache/catcache.o \
 utils/cache/evtcache.o \
 utils/cache/inval.o \
 utils/cache/lsyscache.o \
 utils/cache/partcache.o \
 utils/cache/plancache.o \
 utils/cache/relcache.o \
 utils/cache/relfilenumbermap.o \
 utils/cache/relmapper.o \
 utils/cache/spccache.o \
 utils/cache/syscache.o \
 utils/cache/ts_cache.o \
 utils/cache/typcache.o \
 utils/error/assert.o \
 utils/error/csvlog.o \
 utils/error/elog.o \
 utils/error/jsonlog.o \
 utils/fmgr/dfmgr.o \
 utils/fmgr/fmgr.o \
 utils/fmgr/funcapi.o \
 utils/hash/dynahash.o \
 utils/hash/pg_crc.o \
 utils/init/globals.o \
 utils/init/miscinit.o \
 utils/init/postinit.o \
 utils/init/usercontext.o \
 utils/mb/conv.o \
 utils/mb/mbutils.o \
 utils/mb/stringinfo_mb.o \
 utils/mb/wstrcmp.o \
 utils/mb/wstrncmp.o \
 utils/misc/conffiles.o \
 utils/misc/guc.o \
 utils/misc/guc-file.o \
 utils/misc/guc_funcs.o \
 utils/misc/guc_tables.o \
 utils/misc/help_config.o \
 utils/misc/pg_config.o \
 utils/misc/pg_controldata.o \
 utils/misc/pg_rusage.o \
 utils/misc/ps_status.o \
 utils/misc/queryenvironment.o \
 utils/misc/rls.o \
 utils/misc/sampling.o \
 utils/misc/superuser.o \
 utils/misc/timeout.o \
 utils/misc/tzparser.o \
 utils/mmgr/alignedalloc.o \
 utils/mmgr/aset.o \
 utils/mmgr/dsa.o \
 utils/mmgr/freepage.o \
 utils/mmgr/generation.o \
 utils/mmgr/mcxt.o \
 utils/mmgr/memdebug.o \
 utils/mmgr/portalmem.o \
 utils/mmgr/slab.o \
 utils/resowner/resowner.o \
 utils/sort/logtape.o \
 utils/sort/qsort_interruptible.o \
 utils/sort/sharedtuplestore.o \
 utils/sort/sortsupport.o \
 utils/sort/tuplesort.o \
 utils/sort/tuplesortvariants.o \
 utils/sort/tuplestore.o \
 utils/time/combocid.o \
 utils/time/snapmgr.o \
 utils/fmgrtab.o \
 ../../src/timezone/localtime.o \
 ../../src/timezone/pgtz.o \
 ../../src/timezone/strftime.o \
 jit/jit.o \
 ../../src/common/libpgcommon_srv.a \
 ../../src/port/libpgport_srv.a \
 -L../../src/port \
 -L../../src/common \
 \
 ../../wasi_dlfcn.o \
    ../../src/backend/snowball/libdict_snowball.a \
    ../../src/pl/plpgsql/src/libplpgsql.a \
 \
 -lz -lm -lwasi-emulated-mman -lwasi-emulated-signal -lc -Wl,--export=dsnowball_init


cp -vf postgres postgres.wasi || exit 192
#cp -vf postgres.wasi /tmp/pglite/bin/postgres.wasi

popd
