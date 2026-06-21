package;

import ale.cpp.macros.ExternsGeneratorMacro;
import ale.cpp.macros.TypeConfig;

import sys.io.File;

import haxe.Json;

typedef ExternsConfig = {
    path:String,
    classes:Array<TypeConfig>
}

class InitMacros
{
    public static function main()
    {
        final config:ExternsConfig = cast Json.parse(File.getContent('externsConfig.json'));

        ExternsGeneratorMacro.PATH = config.path;

        ExternsGeneratorMacro.generate(config.classes);
    }
}