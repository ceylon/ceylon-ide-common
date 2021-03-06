import org.eclipse.ceylon.ide.common.model.delta {
    structuralChange
}
import ceylon.test {
    test
}

test void addAnnotation() {
    comparePhasedUnits {
        path = "dir/test.ceylon";
        oldContents =
                "shared abstract class Test() {
                 }";
        newContents =
                "shared sealed abstract class Test() {
                 }";
        expectedDelta =
                RegularCompilationUnitDeltaMockup {
            changedElementString = "Unit[test.ceylon]";
            changes = {};
            childrenDeltas = {
                TopLevelDeclarationDeltaMockup {
                    changedElementString = "Class[Test]";
                    changes = { structuralChange };
                    childrenDeltas = {};
                }
            };
        };
    };
}

test void ignoredAnnotations() {
    comparePhasedUnits {
        path = "dir/test.ceylon";
        oldContents =
                "doc(\"my doc\")
                 by(\"David Festal\")
                 license(\"LGPL\")
                 shared abstract class Test() {
                 }";
        newContents =
                "shared abstract class Test() {
                 }";
        expectedDelta =
                RegularCompilationUnitDeltaMockup {
            changedElementString = "Unit[test.ceylon]";
            changes = {};
            childrenDeltas = {};
        };
    };
}

test void removeAnnotation() {
    comparePhasedUnits {
        path = "dir/test.ceylon";
        oldContents =
                "shared abstract class Test() {
                 }";
        newContents =
                "shared class Test() {
                 }";
        expectedDelta =
                RegularCompilationUnitDeltaMockup {
            changedElementString = "Unit[test.ceylon]";
            changes = {};
            childrenDeltas = {
                TopLevelDeclarationDeltaMockup {
                    changedElementString = "Class[Test]";
                    changes = { structuralChange };
                    childrenDeltas = {};
                }
            };
        };
    };
}

test void changeAnnotationOrder() {
    comparePhasedUnits {
        path = "dir/test.ceylon";
        oldContents =
                "sealed shared abstract class Test() {
                 }";
        newContents =
                "shared sealed abstract class Test() {
                 }";
        expectedDelta =
                RegularCompilationUnitDeltaMockup {
            changedElementString = "Unit[test.ceylon]";
            changes = {};
            childrenDeltas = {};
        };
    };
}

test void changeAnnotationParameter() {
    comparePhasedUnits {
        path = "dir/test.ceylon";
        oldContents =
                "shared abstract truc(true) class Test() {
                 }";
        newContents =
                "shared abstract truc(false) class Test() {
                 }";
        expectedDelta =
                RegularCompilationUnitDeltaMockup {
            changedElementString = "Unit[test.ceylon]";
            changes = {};
            childrenDeltas = {
                TopLevelDeclarationDeltaMockup {
                    changedElementString = "Class[Test]";
                    changes = { structuralChange };
                    childrenDeltas = {};
                }
            };
        };
    };
}

test void addAliasedAnnotation() {
    comparePhasedUnits {
        path = "dir/test.ceylon";
        oldContents =
                "
                 doc class Test() {
                 }
                 ";
        newContents =
                "
                 import ceylon.language {
                     doc=sealed
                 }
                 doc class Test() {
                 }
                 ";
        expectedDelta =
                RegularCompilationUnitDeltaMockup {
            changedElementString = "Unit[test.ceylon]";
            changes = {};
            childrenDeltas = {
                TopLevelDeclarationDeltaMockup {
                    changedElementString = "Class[Test]";
                    changes = { structuralChange};
                    childrenDeltas = {};
                }
            };
        };
    };
}

