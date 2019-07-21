#!/bin/sh
/usr/bin/protoc --proto_path=lib/src --$1_out=lib/build/$1 lib/src/$2/$3.proto
