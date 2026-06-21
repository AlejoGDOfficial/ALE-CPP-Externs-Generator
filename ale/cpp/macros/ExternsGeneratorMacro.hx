package ale.cpp.macros;

import haxe.macro.TypeTools;
import haxe.macro.Context;
import haxe.macro.Expr;

class ExternsGeneratorMacro
{
    public static var PATH:String = '';

    public static function generate(types:Array<TypeConfig>)
    {
        for (type in types)
        {
            if (type == null)
                continue;

            final path:String = PATH + type.file + '.cpp';

            final clsPack:Array<String> = type.name.split('.');
            final clsName:String = clsPack.pop();

            Context.defineType({
                name: clsName,
                pack: clsPack,
                kind: TDClass(null, null, false),
                meta: [
                    {
                        name: ':include',
                        params: [
                            macro $v{path},
                        ],
                        pos: Context.currentPos()
                    }
                ],
                isExtern: true,
                fields: [
                    for (field in type.fields)
                    {
                        field.returnType ??= 'Void';

                        {
                            name: field.name,
                            access: [APublic, AStatic],
                            meta: [{
                                name: ':native',
                                params: [ macro 'example' ],
                                pos: Context.currentPos()
                            }],
                            kind: FFun({
                                args: [
                                    for (arg in field.arguments)
                                    {
                                        arg.optional ??= false;

                                        {
                                            name: arg.name,
                                            type: TypeTools.toComplexType(Context.getType(arg.type)),
                                            opt: arg.optional
                                        }
                                    }
                                ],
                                ret: TypeTools.toComplexType(Context.getType(field.returnType))
                            }),
                            pos: Context.currentPos()
                        }
                    }
                ],
                pos: Context.currentPos()
            });
        }
    }
}