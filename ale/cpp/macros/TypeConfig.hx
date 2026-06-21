package ale.cpp.macros;

typedef TypeConfig = {
    name:String,
    file:String,
    ?functions:Array<TypeConfigFunction>,
    ?variables:Array<TypeConfigVariable>
}