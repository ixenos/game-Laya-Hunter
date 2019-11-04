self.addEventListener("message",function(e)
{

console.log(e)
for(var i in e.data[0])
{
    console.log(i+":"+e.data[0][i])
}
switch(e.data[0].type)
{
    case "equip"://进行装备检查
    checkEquip();
    break;
}
function checkEquip()
{
  console.log("进行装备检查")
}
self.postMessage("hello")
},false)