export RES=_result
export PROFRAW=$RES/profraw
export COVERAGE=$RES/coverage
export APP=./bin/cjson_fuzz_target

mkdir -p $PROFRAW
mkdir -p $COVERAGE

export LLVM_PROFILE_FILE="$PROFRAW/profile-%p-%m.profraw"

afl-fuzz -i fuzz_in/ -o fuzz_out -x cjson.dict -V 20 -- $APP

llvm-profdata merge $PROFRAW/*.profraw --output $COVERAGE/result.profdata

llvm-cov export $APP -instr-profile=$COVERAGE/result.profdata -format=lcov > $COVERAGE/coverage.info

genhtml -o $COVERAGE/html $COVERAGE/coverage.info
