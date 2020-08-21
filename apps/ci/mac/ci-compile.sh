#!/usr/bin/env bash

export CCACHE_CPP2=true
export CCACHE_MAXSIZE='500MB'
export CCACHE_SLOPPINESS=pch_defines,time_macros,include_file_mtime,include_file_ctime,file_stat_matches
ccache -s

mkdir var/build/obj && cd var/build/obj;

time cmake ../../../ \
-DTOOLS=1 \
-DUNIT_TESTS=1 \
-DSCRIPTS=0 \
-DSERVERS=0 \
-DCMAKE_BUILD_TYPE=Debug \
-DUSE_SCRIPTPCH=0 \
-DUSE_COREPCH=0 \
-DMYSQL_ADD_INCLUDE_PATH=/usr/local/include \
-DMYSQL_LIBRARY=/usr/local/lib/libmysqlclient.dylib \
-DREADLINE_INCLUDE_DIR=/usr/local/opt/readline/include \
-DREADLINE_LIBRARY=/usr/local/opt/readline/lib/libreadline.dylib \
-DOPENSSL_INCLUDE_DIR=/usr/local/opt/openssl/include \
-DOPENSSL_SSL_LIBRARIES=/usr/local/opt/openssl/lib/libssl.dylib \
-DOPENSSL_CRYPTO_LIBRARIES=/usr/local/opt/openssl/lib/libcrypto.dylib \
-DCMAKE_C_FLAGS="-Werror" \
-DCMAKE_CXX_FLAGS="-Werror" \
-DCMAKE_C_COMPILER_LAUNCHER=ccache \
-DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
;

time make -j $(($(sysctl -n hw.ncpu ) + 2))

ccache -s
