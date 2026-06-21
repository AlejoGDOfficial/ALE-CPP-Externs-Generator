package ale.cpp.macros;

import haxe.macro.TypeTools;
import haxe.macro.Context;
import haxe.macro.Expr;

class ExternsGeneratorMacro
{
    public static var PATH:String = '';

    static function resolveType(type:TypeConfigType):ComplexType
    {
        final pack:Array<String> = type.path.split('.');

        final name:String = pack.pop();

        final params:Array<TypeParam> = [];

        if (type.params != null)
            for (param in type.params)
                params.push(TPType(resolveType(param)));

        return TPath({
            name: name,
            pack: pack,
            params: params
        });
    }

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
                    for (field in type.functions)
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
                                            type: resolveType(arg.type ?? {
                                                path: 'Dynamic' 
                                            }),
                                            opt: arg.optional
                                        }
                                    }
                                ],
                                ret: resolveType(field.type ?? {
                                    path: 'Void'
                                })
                            }),
                            pos: Context.currentPos()
                        }
                ],
                pos: Context.currentPos()
            });
        }
    }
}