//提示弹框
function firstClick(message){
    alert("点击成功");
}

//确认弹框
function secondClick(){
    var con=confirm("喜欢玫瑰花吗？");
    if(con==true)
        alert("非常喜欢!");
    else alert("不喜欢!");
}

//输入弹框
function thirdClick(){
    var name=prompt("请问你叫什么名字?");
    alert(name);
}

//js交互方式一: 通过拦截url方式, 网址中拼接的内容
function normalClick() {
    LoadUrl("app://shareClick?title=分享的标题&content=分享的内容&url=链接地址&imagePath=图片地址");
}

function LoadUrl(url){
    var iFrame;
    iFrame = document.createElement("iframe");
    iFrame.setAttribute("src", url);
    document.body.appendChild(iFrame);
    iFrame.parentNode.removeChild(iFrame);
    iFrame = null;
}

//js交互方式二: 使用js传值
function JSClick(array) {
    WKClick(array);
}

//WKWebView通过js调用OC
function WKClick(array) {
    window.webkit.messageHandlers.universal.postMessage(array);
}

//UIWebView通过js调用OC
function UIClick(array) {
    
}

//自定义
function asyncAlert(content) {
    setTimeout(function(){
               alert(content);
               },1);
}
