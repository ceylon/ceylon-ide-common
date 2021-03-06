/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import org.eclipse.ceylon.ide.common.typechecker {
    ExternalPhasedUnit
}
import org.eclipse.ceylon.ide.common.util {
    SingleSourceUnitPackage,
    equalsWithNulls
}
import org.eclipse.ceylon.model.typechecker.model {
    Declaration,
    Package,
    Scope,
    Value
}

import java.util {
    Stack
}
"
 Used when the external declarations come from a source archive
 "
shared class ExternalSourceFile(ExternalPhasedUnit thePhasedUnit) 
        extends SourceFile(thePhasedUnit) {
        
        modifiable => false;
        
        shared actual default ExternalPhasedUnit? phasedUnit {
            assert (is ExternalPhasedUnit? phasedUnit 
                        = super.phasedUnit);
            return phasedUnit;
        }
        
        shared Boolean binaryDeclarationSource 
                => ceylonModule.isCeylonBinaryArchive && 
                ceylonPackage is SingleSourceUnitPackage;
        
        // TODO : check this method !!!
        shared Declaration? retrieveBinaryDeclaration(Declaration sourceDeclaration) {
            if (!equalsWithNulls(this, sourceDeclaration.unit)) {
                return null;
            }
            variable Declaration? binaryDeclaration = null;
            if (binaryDeclarationSource) {
                assert(is SingleSourceUnitPackage sourceUnitPackage = \ipackage);
                Package binaryPackage = sourceUnitPackage.modelPackage;
                value ancestors = Stack<Declaration>();
                variable Scope container = sourceDeclaration.container;
                while (is Declaration ancestor = container) {
                    ancestors.push(ancestor);
                    container = ancestor.container;
                }
                if (container==sourceUnitPackage) {
                    variable Scope? currentBinaryScope = binaryPackage;
                    while (!ancestors.empty()) {
                        variable Declaration? binaryAncestor 
                                = currentBinaryScope?.getDirectMember(
                                    ancestors.pop().name, null, false);
                        if (is Value valueAncestor = binaryAncestor) {
                            binaryAncestor = valueAncestor.typeDeclaration;
                        }
                        if (is Scope scopeAncestor = binaryAncestor) {
                            currentBinaryScope = scopeAncestor;
                        }
                        else {
                            break;
                        }
                    }
                    if (exists foundBinaryScope = currentBinaryScope) {
                        binaryDeclaration = 
                                foundBinaryScope.getDirectMember(
                                    sourceDeclaration.name, null, false);
                    }
                }
            }
            return binaryDeclaration;
        }
    }
