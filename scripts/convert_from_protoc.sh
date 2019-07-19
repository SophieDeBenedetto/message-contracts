#!/bin/bash
protoc --proto_path=lib/src --$1_out=lib/build/$1 lib/src/$2.proto
