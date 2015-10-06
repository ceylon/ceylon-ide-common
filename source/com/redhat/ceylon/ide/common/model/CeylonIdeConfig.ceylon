import com.redhat.ceylon.common.config {
    CeylonConfig,
    Repositories,
    CeylonConfigFinder,
    ConfigWriter
}
import java.io {
    File,
    FileReader,
    IOException
}
import java.lang {
    JBoolean=Boolean
}
import java.util {
    Properties
}
import ceylon.interop.java {
    CeylonIterable
}
import java.util.regex {
    Pattern
}

shared interface JavaToCeylonConverterConfig {
    shared formal Boolean transformGetters;
    shared formal Boolean useVariableInParameters;
    shared formal Boolean useVariableInLocals;
    shared formal Boolean useValues;
}

shared class CeylonIdeConfig(shared BaseCeylonProject project) {
    late variable CeylonConfig mergedConfig;
    late variable CeylonConfig ideConfig;
    late variable Repositories mergedRepositories;
    late variable Repositories projectRepositories;

    variable Boolean? transientCompileToJvm = null;
    variable Boolean? transientCompileToJs = null;
    variable String? transientSystemRepository = null;

    variable Boolean isCompileToJvmChanged = false;
    variable Boolean isCompileToJsChanged = false;
    variable Boolean isSystemRepositoryChanged = false;

    File ideConfigFile => File(File(project.rootDirectory, ".ceylon"), "ide-config");

    void initMergedConfig() {
        mergedConfig = CeylonConfig.createFromLocalDir(project.rootDirectory);
        mergedRepositories = Repositories.withConfig(mergedConfig);
    }

    void initIdeConfig() {
        File configFile = ideConfigFile;
        variable CeylonConfig? searchedConfig = null;
        if (configFile.\iexists() && configFile.file) {
            try {
                searchedConfig = CeylonConfigFinder.loadConfigFromFile(configFile);
            } catch (IOException e) {
                throw Exception(null, e);
            }
        }
        if (exists existingConfig=searchedConfig) {
            ideConfig = existingConfig;
        } else {
            ideConfig = CeylonConfig();
        }
        projectRepositories = Repositories.withConfig(ideConfig);
    }

    initMergedConfig();
    initIdeConfig();

    shared Boolean? compileToJvm => let (JBoolean? option = ideConfig.getBoolOption("project.compile-jvm")) option?.booleanValue();
    assign compileToJvm {
        this.isCompileToJvmChanged = true;
        this.transientCompileToJvm = compileToJvm;
    }

    shared Boolean? compileToJs => let (JBoolean? option = ideConfig.getBoolOption("project.compile-js")) option?.booleanValue();
    assign compileToJs {
        this.isCompileToJsChanged = true;
        this.transientCompileToJs = compileToJs;
    }

    shared String? systemRepository => ideConfig.get("project.system-repository");
    assign systemRepository {
        this.isSystemRepositoryChanged = true;
        this.transientSystemRepository = systemRepository;
    }

    shared JavaToCeylonConverterConfig converterConfig => object satisfies JavaToCeylonConverterConfig {
        shared actual Boolean transformGetters => ideConfig.getBoolOption("converter.transform-getters", true);
        shared actual Boolean useValues => ideConfig.getBoolOption("converter.use-values", false);
        shared actual Boolean useVariableInLocals => ideConfig.getBoolOption("converter.use-variable-in-locals", true);
        shared actual Boolean useVariableInParameters => ideConfig.getBoolOption("converter.use-variable-in-parameters", true);
    };

    shared String? getSourceAttachment(String moduleName, String moduleVersion) {
        value propertiesFile = File(
            project.rootDirectory,
            ideConfig.getOption(
                "source.attachments",
                ".ceylon/attachments.properties"));

        value optionPattern = "^(``Pattern.quote(moduleName)``|\\*)/(``Pattern.quote(moduleVersion)``|\\*)/path";

        if (propertiesFile.\iexists()) {
            value properties = Properties();
            properties.load(FileReader(propertiesFile));
            value srcPaths =
                    CeylonIterable(properties.stringPropertyNames())
                    .filter((name)=> name.matches(optionPattern))
                    .map((s)=>s.string)
                    .sort((x, y) => x.count('*'.equals) <=> y.count('*'.equals))
                    .map((name) => properties.getProperty(name.string));
            return srcPaths.first;
        }

        return null;
    }

    shared void refresh() {
        initMergedConfig();
        initIdeConfig();

        isCompileToJvmChanged = false;
        isCompileToJsChanged = false;
        isSystemRepositoryChanged = false;

        transientCompileToJvm = null;
        transientCompileToJs = null;
        transientSystemRepository = null;
    }

    shared void save() {
        initIdeConfig();

        Boolean someSettingsChanged = isCompileToJsChanged || isCompileToJsChanged || isSystemRepositoryChanged;

        if (!ideConfigFile.\iexists() || someSettingsChanged) {
            try {
                ideConfig.setBoolOption("project.compile-jvm", transientCompileToJvm else false);
                ideConfig.setBoolOption("project.compile-js", transientCompileToJs else false);
                ideConfig.setOption("project.system-repository", transientSystemRepository else "");

                ConfigWriter.write(ideConfig, ideConfigFile);
                refresh();
            } catch (IOException e) {
                throw Exception("", e);
            }
        }
    }
}
