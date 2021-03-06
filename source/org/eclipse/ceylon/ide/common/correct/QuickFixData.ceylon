/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import org.eclipse.ceylon.cmr.api {
    ModuleVersionDetails
}
import org.eclipse.ceylon.compiler.typechecker.context {
    PhasedUnit
}
import org.eclipse.ceylon.compiler.typechecker.tree {
    Tree,
    Node
}
import org.eclipse.ceylon.ide.common.doc {
    Icons
}
import org.eclipse.ceylon.ide.common.model {
    BaseCeylonProject
}
import org.eclipse.ceylon.ide.common.platform {
    CommonDocument,
    TextChange
}
import org.eclipse.ceylon.ide.common.refactoring {
    DefaultRegion
}
import org.eclipse.ceylon.model.typechecker.model {
    Referenceable
}

import java.util {
    JList=List
}

import org.antlr.runtime {
    CommonToken
}

shared interface QuickFixData {
    shared formal Integer errorCode;
    shared formal Integer problemOffset;
    shared formal Integer problemLength;
    shared formal Node node;
    shared formal Tree.CompilationUnit rootNode;
    shared formal PhasedUnit phasedUnit;
    shared JList<CommonToken> tokens => phasedUnit.tokens;
    shared formal BaseCeylonProject ceylonProject;
    shared formal CommonDocument document;
    shared formal DefaultRegion editorSelection;
    "Set this flag to [[true]] to avoid heavy computations and delay them
     until the quick fix is called."
    shared default Boolean useLazyFixes => false;
    
    shared formal void addQuickFix(String description, TextChange|Anything() change,
        DefaultRegion? selection = null, 
        Boolean qualifiedNameIsPath = false,
        Icons? image = null,
        QuickFixKind kind = QuickFixKind.generic,
        String? hint = null,
        Boolean asynchronous = false,
        Referenceable|ModuleVersionDetails? declaration = null,
        Boolean affectsOtherUnits = false);
    
    shared formal void addConvertToClassProposal(String description,
        Tree.ObjectDefinition declaration);
    shared formal void addAssignToLocalProposal(String description);
}

shared class QuickFixKind
        of generic | addConstructor | addParameterList | addRefineEqualsHash
         | addRefineFormal | addModuleImport | addImport {
    shared new addImport {}
    shared new addModuleImport {}
    shared new addRefineFormal {}
    shared new addRefineEqualsHash {}
    shared new addParameterList {}
    shared new addConstructor {}
    shared new generic {}
}
