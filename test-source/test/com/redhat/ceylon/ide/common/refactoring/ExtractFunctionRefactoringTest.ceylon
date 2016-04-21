import ceylon.file {
    lines,
    File,
    Directory
}
import ceylon.test {
    test,
    fail,
    assertEquals
}

import com.redhat.ceylon.ide.common.platform {
    DefaultDocument,
    DefaultTextChange
}
import com.redhat.ceylon.ide.common.refactoring {
    createExtractFunctionRefactoring
}

import test.com.redhat.ceylon.ide.common.platform {
    testPlatform
}
import test.com.redhat.ceylon.ide.common.testUtils {
    parseAndTypecheckCode,
    SourceCode,
    resourcesRootForPackage
}

Directory resourcesRoot = resourcesRootForPackage(`package`);

void testRefactoring(String unitName, Integer selectionStart, Integer selectionEnd) {
    testPlatform.register();
    
    value fileName = "extractFunction/" + unitName + "Before.ceylon";
    assert(is File file=resourcesRoot.childResource(fileName));
    value code = SourceCode("\n".join(lines(file)), fileName);
    assert(exists phasedUnit = parseAndTypecheckCode({code}).first?.item);

    value doc = DefaultDocument(code.contents);
    value refactoring = createExtractFunctionRefactoring { 
        doc = doc;
        selectionStart = selectionStart;
        selectionEnd = selectionEnd;
        rootNode = phasedUnit.compilationUnit;
        tokens = phasedUnit.tokens;
        target = null;
        moduleUnits = {phasedUnit};
        vfile = phasedUnit.unitFile;
    };
    assert (exists refactoring);
    switch (change = refactoring.build())
    case (is DefaultTextChange) {
        change.applyChanges();
    } else {
        fail("Can't apply changes to ``className(change)``");
    }
    
    assert(is File expected=resourcesRoot.childResource(
        "extractFunction/" + unitName + "After.ceylon"));
    assertEquals("\n".join(lines(expected)), doc.text);
}

test void testExtractSimpleFunction()
        => testRefactoring("simple", 23, 29);

test void testExtractFunctionWithParameters()
        => testRefactoring("simpleWithParam", 48, 91);