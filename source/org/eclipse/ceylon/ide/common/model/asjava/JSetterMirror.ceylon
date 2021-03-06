/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import org.eclipse.ceylon.model.loader.mirror {
    TypeParameterMirror,
    VariableMirror
}
import org.eclipse.ceylon.model.typechecker.model {
    Value
}

import java.util {
    Collections
}

shared class JSetterMirror(Value decl)
        extends AbstractMethodMirror(decl) {
    
    constructor => false;
    
    declaredVoid => true;

    final => true;
    
    name => "set" + capitalize(decl.name);
    
    parameters
            => Collections.singletonList<VariableMirror>(JVariableMirror(decl));
    
    returnType => JTypeMirror(decl.type);
    
    typeParameters
            => Collections.emptyList<TypeParameterMirror>();
    
    variadic => false;
    
    defaultMethod => false;
    
    String capitalize(String str) 
            => (str.first?.uppercased?.string else "") + str.rest;
}