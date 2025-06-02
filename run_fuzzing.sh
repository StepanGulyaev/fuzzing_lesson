export RES=_result
export PROFRAW=$RES/profraw
export COVERAGE=$RES/coverage
export APP=./bin/cjson_fuzz_target

mkdir -p $PROFRAW
mkdir -p $COVERAGE

export LLVM_PROFILE_FILE="$PROFRAW/profile-%p-%m.profraw"

export AFL_TESTCACHE_SIZE=5000
export AFL_IMPORT_FIRST=1

AFL_FINAL_SYNC=1 afl-fuzz -i fuzz_in/ -o fuzz_out -x cjson.dict -V 20 -M fuzzer_main -- $APP & pids+=($!)

export AFL_NO_UI=1
afl-fuzz -i fuzz_in/ -o fuzz_out -x cjson.dict -V 15 -S fuzzer_asan -- $APP_asan > /dev/null & pids+=($!)
afl-fuzz -i fuzz_in/ -o fuzz_out -x cjson.dict -V 15 -S fuzzer_cmplog -- $APP_cmplog > /dev/null & pids+=($!)

for pid in "${pids[@]}"; do
	wait "${pid}"
done

llvm-profdata merge $PROFRAW/*.profraw --output $COVERAGE/result.profdata

llvm-cov export $APP -instr-profile=$COVERAGE/result.profdata -format=lcov > $COVERAGE/coverage.info

genhtml -o $COVERAGE/html $COVERAGE/coverage.info
