/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
package org.eclipse.ceylon.ide.common.util;

import java.io.File;
import java.io.IOException;
import java.util.Properties;

import net.lingala.zip4j.core.ZipFile;
import net.lingala.zip4j.exception.ZipException;
import net.lingala.zip4j.io.ZipInputStream;
import net.lingala.zip4j.model.FileHeader;

@Deprecated
public class CarUtils {

    public static Properties retrieveMappingFile(File carFile) {
        if (carFile != null) {
            try {
                return retrieveMappingFile(new ZipFile(carFile));
            } catch (ZipException e) {
                e.printStackTrace();
            }
        }
        return new Properties();
    }

    //still used by Eclipse IDE:
    public static Properties retrieveMappingFile(ZipFile carFile) {
        Properties mapping = new Properties();
        if (carFile != null && carFile.isValidZipFile()) {
            FileHeader fileHeader;
            try {
                fileHeader = carFile.getFileHeader("META-INF/mapping.txt");
                if (fileHeader != null) {
                    ZipInputStream zis = carFile.getInputStream(fileHeader);
                    try {
                        mapping.load(zis);
                    } finally {
                        zis.close();
                    }
                }
            } catch (ZipException | IOException e) {
                e.printStackTrace();
            }
        }
        return mapping;
    }

}
