package;

import util.CPPExternMacro;

class InitMacros
{
    public static function main()
    {
        final config:{path:String, classes:Array<TypeConfig>} = cast haxe.Json.parse(sys.io.File.getContent('externsConfig.json'));

        CPPExternMacro.PATH = config.path;

        CPPExternMacro.generate(config.classes);
    }
}