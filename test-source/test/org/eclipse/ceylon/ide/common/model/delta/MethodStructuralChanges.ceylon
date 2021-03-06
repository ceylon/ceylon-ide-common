import org.eclipse.ceylon.ide.common.model.delta {
    structuralChange
}
import ceylon.test {
    test
}

test void methodParametersChanged() {
    comparePhasedUnits {
        path = "dir/test.ceylon";
        oldContents =
                "
                 shared void test(Integer a) {}
                 ";
        newContents =
                "
                 shared void test(Integer a, Float b) {}
                 ";
        expectedDelta =
                RegularCompilationUnitDeltaMockup {
            changedElementString = "Unit[test.ceylon]";
            changes = { };
            childrenDeltas = {
                TopLevelDeclarationDeltaMockup {
                    changedElementString = "Function[test]";
                    changes = { structuralChange };
                    childrenDeltas = {};
                }
            };
        };
        void doWithNodeComparisons({NodeComparison*} comparisons) {
            assert(comparisons.contains(["dir::test", "parameterLists",
                "ParameterList[ValueParameterDeclaration[AttributeDeclaration[AnnotationList[]Identifier[a]Type[ceylon.language::Integer]]]]"
                        -> "ParameterList[ValueParameterDeclaration[AttributeDeclaration[AnnotationList[]Identifier[a]Type[ceylon.language::Integer]]]"
                                +"ValueParameterDeclaration[AttributeDeclaration[AnnotationList[]Identifier[b]Type[ceylon.language::Float]]]]"]));
        }
    };
}

test void methodParameterNameChanged() {
    comparePhasedUnits {
        path = "dir/test.ceylon";
        oldContents =
                "
                 shared void test(Integer a) {}
                 ";
        newContents =
                "
                 shared void test(Integer aChanged) {}
                 ";
        expectedDelta =
                RegularCompilationUnitDeltaMockup {
            changedElementString = "Unit[test.ceylon]";
            changes = { };
            childrenDeltas = {
                TopLevelDeclarationDeltaMockup {
                    changedElementString = "Function[test]";
                    changes = { structuralChange };
                    childrenDeltas = {};
                }
            };
        };
        void doWithNodeComparisons({NodeComparison*} comparisons) {
            assert(comparisons.contains(["dir::test", "parameterLists",
                "ParameterList[ValueParameterDeclaration[AttributeDeclaration[AnnotationList[]Identifier[a]Type[ceylon.language::Integer]]]]"
                        -> "ParameterList[ValueParameterDeclaration[AttributeDeclaration[AnnotationList[]Identifier[aChanged]Type[ceylon.language::Integer]]]]"]));
        }
    };
}

test void methodParameterDefaultValueAdded() {
    comparePhasedUnits {
        path = "dir/test.ceylon";
        oldContents =
                "
                 shared void test(Integer a) {}
                 ";
        newContents =
                "
                 shared void test(Integer a=0) {}
                 ";
        expectedDelta =
                RegularCompilationUnitDeltaMockup {
            changedElementString = "Unit[test.ceylon]";
            changes = { };
            childrenDeltas = {
                TopLevelDeclarationDeltaMockup {
                    changedElementString = "Function[test]";
                    changes = { structuralChange };
                    childrenDeltas = {};
                }
            };
        };
        void doWithNodeComparisons({NodeComparison*} comparisons) {
            assert(comparisons.contains(["dir::test", "parameterLists",
                "ParameterList[ValueParameterDeclaration[AttributeDeclaration[AnnotationList[]Identifier[a]Type[ceylon.language::Integer]]]]"
             -> "ParameterList[ValueParameterDeclaration[AttributeDeclaration[AnnotationList[]Identifier[a]Type[ceylon.language::Integer]SpecifierExpression[Expression[NaturalLiteral[]]]]]]"]));
        }
    };
}

test void methodParameterDefaultValueTypeChanged() {
    comparePhasedUnits {
        path = "dir/test.ceylon";
        oldContents =
                "
                 shared void test(Object a=0) {}
                 ";
        newContents =
                "
                 shared void test(Object a=1.0) {}
                 ";
        expectedDelta =
                RegularCompilationUnitDeltaMockup {
            changedElementString = "Unit[test.ceylon]";
            changes = { };
            childrenDeltas = {
                TopLevelDeclarationDeltaMockup {
                    changedElementString = "Function[test]";
                    changes = { structuralChange };
                    childrenDeltas = {};
                }
            };
        };
        void doWithNodeComparisons({NodeComparison*} comparisons) {
            assert(comparisons.contains(["dir::test", "parameterLists",
                "ParameterList[ValueParameterDeclaration[AttributeDeclaration[AnnotationList[]Identifier[a]Type[ceylon.language::Object]SpecifierExpression[Expression[NaturalLiteral[]]]]]]"
             -> "ParameterList[ValueParameterDeclaration[AttributeDeclaration[AnnotationList[]Identifier[a]Type[ceylon.language::Object]SpecifierExpression[Expression[FloatLiteral[]]]]]]"]));
        }
    };
}

test void methodFunctionalParameterArgumentNameChanged() {
    comparePhasedUnits {
        path = "dir/test.ceylon";
        oldContents =
                "
                 shared void test(void functionalParameter(Integer a)) {}
                 ";
        newContents =
                "
                 shared void test(void functionalParameter(Integer a2)) {}
                 ";
        expectedDelta =
                RegularCompilationUnitDeltaMockup {
            changedElementString = "Unit[test.ceylon]";
            changes = { };
            childrenDeltas = { };
        };
        void doWithNodeComparisons({NodeComparison*} comparisons) {
            assert(comparisons.contains(["dir::test", "parameterLists",
                "ParameterList[FunctionalParameterDeclaration[MethodDeclaration[AnnotationList[]Identifier[functionalParameter]"
                        + "VoidModifier[ceylon.language::Anything]ParameterList[ValueParameterDeclaration[AttributeDeclaration[AnnotationList[]Type[ceylon.language::Integer]]]]]]]"
             -> "ParameterList[FunctionalParameterDeclaration[MethodDeclaration[AnnotationList[]Identifier[functionalParameter]"
                        + "VoidModifier[ceylon.language::Anything]ParameterList[ValueParameterDeclaration[AttributeDeclaration[AnnotationList[]Type[ceylon.language::Integer]]]]]]]"]));
        }
    };
}

test void methodFunctionalParameterNameChanged() {
    comparePhasedUnits {
        path = "dir/test.ceylon";
        oldContents =
                "
                 shared void test(void functionalParameter(Integer a)) {}
                 ";
        newContents =
                "
                 shared void test(void functionalParameterChanged(Integer a)) {}
                 ";
        expectedDelta =
                RegularCompilationUnitDeltaMockup {
            changedElementString = "Unit[test.ceylon]";
            changes = { };
            childrenDeltas = {
                TopLevelDeclarationDeltaMockup {
                    changedElementString = "Function[test]";
                    changes = { structuralChange };
                    childrenDeltas = {};
                }
            };
        };
        void doWithNodeComparisons({NodeComparison*} comparisons) {
            assert(comparisons.contains(["dir::test", "parameterLists",
                "ParameterList[FunctionalParameterDeclaration[MethodDeclaration[AnnotationList[]Identifier[functionalParameter]VoidModifier[ceylon.language::Anything]"
                    + "ParameterList[ValueParameterDeclaration[AttributeDeclaration[AnnotationList[]Type[ceylon.language::Integer]]]]]]]"
             -> "ParameterList[FunctionalParameterDeclaration[MethodDeclaration[AnnotationList[]Identifier[functionalParameterChanged]VoidModifier[ceylon.language::Anything]"
                    + "ParameterList[ValueParameterDeclaration[AttributeDeclaration[AnnotationList[]Type[ceylon.language::Integer]]]]]]]"]));
        }
    };
}

// For the moment we consider these 2 case as different, though externally it might be seen as the same
test void methodEquivalentFunctionalParameter() {
    comparePhasedUnits {
        path = "dir/test.ceylon";
        oldContents =
                "
                 shared void test(Anything functionalParameter(Integer a)) {}
                 ";
        newContents =
                "
                 shared void test(Anything(Integer) functionalParameter) {}
                 ";
        expectedDelta =
                RegularCompilationUnitDeltaMockup {
            changedElementString = "Unit[test.ceylon]";
            changes = { };
            childrenDeltas = {
                TopLevelDeclarationDeltaMockup {
                    changedElementString = "Function[test]";
                    changes = { structuralChange };
                    childrenDeltas = {};
                }
            };
        };
        void doWithNodeComparisons({NodeComparison*} comparisons) {
            assert(comparisons.contains(["dir::test", "parameterLists",
                "ParameterList[FunctionalParameterDeclaration[MethodDeclaration[AnnotationList[]Identifier[functionalParameter]Type[ceylon.language::Anything]"
                    + "ParameterList[ValueParameterDeclaration[AttributeDeclaration[AnnotationList[]Type[ceylon.language::Integer]]]]]]]"
             -> "ParameterList[ValueParameterDeclaration[AttributeDeclaration[AnnotationList[]Identifier[functionalParameter]"
                    + "Type[ceylon.language::Anything(ceylon.language::Integer)]]]]"]));
        }
    };
}

test void methodTypeConstraintChanged() {
    comparePhasedUnits {
        path = "dir/test.ceylon";
        oldContents =
                "
                 shared void test<Type1, Type2>()
                        given Type1 satisfies Iterable<Integer>
                        given Type2 satisfies Iterable<Float> {}
                 ";
        newContents =
                "
                 shared void test<Type1, Type2>()
                        given Type1 satisfies Iterable<Float>
                        given Type2 satisfies Iterable<Integer> {}
                 ";
        expectedDelta =
                RegularCompilationUnitDeltaMockup {
            changedElementString = "Unit[test.ceylon]";
            changes = { };
            childrenDeltas = {
                TopLevelDeclarationDeltaMockup {
                    changedElementString = "Function[test]";
                    changes = { structuralChange };
                    childrenDeltas = {};
                }
            };
        };
        void doWithNodeComparisons({NodeComparison*} comparisons) {
            assert(comparisons.contains(["dir::test", "typeConstraintList",
                "TypeConstraintList[TypeConstraint[Identifier[Type1]SatisfiedTypes[Type[{ceylon.language::Integer*}]]]"
                    + "TypeConstraint[Identifier[Type2]SatisfiedTypes[Type[{ceylon.language::Float*}]]]]"
             -> "TypeConstraintList[TypeConstraint[Identifier[Type1]SatisfiedTypes[Type[{ceylon.language::Float*}]]]"
                    + "TypeConstraint[Identifier[Type2]SatisfiedTypes[Type[{ceylon.language::Integer*}]]]]"]));
        }
    };
}
