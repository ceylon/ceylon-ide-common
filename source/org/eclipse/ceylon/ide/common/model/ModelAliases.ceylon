/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
shared interface ModelAliases<NativeProject, NativeResource, NativeFolder, NativeFile>
        given NativeProject satisfies Object
        given NativeResource satisfies Object
        given NativeFolder satisfies NativeResource
        given NativeFile satisfies NativeResource {
    shared alias CeylonProjectAlias => CeylonProject<NativeProject, NativeResource, NativeFolder, NativeFile>;
    shared alias CeylonProjectBuildAlias => CeylonProjectBuild<NativeProject, NativeResource, NativeFolder, NativeFile>;
    shared alias BuildHookAlias => BuildHook<NativeProject, NativeResource, NativeFolder, NativeFile>;
    shared alias CeylonProjectsAlias => CeylonProjects<NativeProject, NativeResource, NativeFolder, NativeFile>;
    shared alias ModelListenerAlias => ModelListener<NativeProject, NativeResource, NativeFolder, NativeFile>;
    shared alias ModelListenerAdapterAlias => ModelListener<NativeProject, NativeResource, NativeFolder, NativeFile>;

    shared alias IdeModuleAlias => IdeModule<NativeProject, NativeResource, NativeFolder, NativeFile>;

    shared alias EditedSourceFileAlias => EditedSourceFile<NativeProject, NativeResource, NativeFolder, NativeFile>;
    shared alias ModifiableSourceFileAlias => ModifiableSourceFile<NativeProject, NativeResource, NativeFolder, NativeFile>;
    shared alias ProjectSourceFileAlias => ProjectSourceFile<NativeProject, NativeResource, NativeFolder, NativeFile>;
    shared alias CrossProjectSourceFileAlias => CrossProjectSourceFile<NativeProject, NativeResource, NativeFolder, NativeFile>;
    shared alias IResourceAwareAlias => IResourceAware<NativeProject, NativeFolder, NativeFile>;
    shared alias ICrossProjectCeylonReferenceAlias => ICrossProjectCeylonReference<NativeProject, NativeResource, NativeFolder, NativeFile>;
    shared alias ICrossProjectReferenceAlias => ICrossProjectReference<NativeProject, NativeFolder, NativeFile>;
    shared alias CeylonBinaryUnitAlias => CeylonBinaryUnit<NativeProject, out Anything, out Anything>;
    shared alias JavaUnitAlias => JavaUnit<NativeProject, NativeFolder, NativeFile, out Anything, out Anything>;
    shared alias JavaCompilationUnitAlias => JavaCompilationUnit<NativeProject, NativeFolder, NativeFile, out Anything, out Anything>;
    shared alias JavaClassFileAlias => JavaClassFile<NativeProject, NativeFolder, NativeFile, out Anything, out Anything>;
        

    shared alias IdeModuleManagerAlias => IdeModuleManager<NativeProject, NativeResource, NativeFolder, NativeFile>;
    shared alias IdeModuleSourceMapperAlias => IdeModuleSourceMapper<NativeProject, NativeResource, NativeFolder, NativeFile>;
}