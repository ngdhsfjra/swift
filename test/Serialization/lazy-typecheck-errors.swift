// Verify the -emit-module job fails with a broken AST.
// RUN: not %target-swift-frontend -emit-module %s -emit-module-path /dev/null -module-name lazy_typecheck -swift-version 5 -enable-library-evolution -parse-as-library -experimental-lazy-typecheck -experimental-skip-all-function-bodies -experimental-skip-non-exportable-decls 2>&1 | %FileCheck %s

// CHECK: <unknown>:0: error: serialization of module 'lazy_typecheck' failed due to the errors above

// Verify typechecking errors are emitted.
// RUN: %target-swift-frontend -emit-module %s -emit-module-path /dev/null -module-name lazy_typecheck -swift-version 5 -enable-library-evolution -parse-as-library -experimental-lazy-typecheck -experimental-skip-all-function-bodies -experimental-skip-non-exportable-decls -verify -verify-ignore-unknown

// Verify output with -Rmodule-serialization.
// RUN: %target-swift-frontend -emit-module %s -emit-module-path /dev/null -module-name lazy_typecheck -swift-version 5 -enable-library-evolution -parse-as-library -experimental-lazy-typecheck -experimental-skip-all-function-bodies -experimental-skip-non-exportable-decls -verify -verify-ignore-unknown -Rmodule-serialization -verify-additional-prefix serialization-

public func returnsInvalidType() -> InvalidType { fatalError() }
// expected-error@-1 {{cannot find type 'InvalidType' in scope}}
// expected-serialization-remark@-2 {{serialization skipped invalid global function 'returnsInvalidType()'}}

public func takesInvalidType(_ x: InvalidType) {}
// expected-error@-1 {{cannot find type 'InvalidType' in scope}}
// expected-serialization-remark@-2 {{serialization skipped invalid global function 'takesInvalidType'}}
