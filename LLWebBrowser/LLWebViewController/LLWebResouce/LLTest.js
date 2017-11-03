function LLAlert(message){
    alert(message);
}

function LLConfirm(){
    var con=confirm("喜欢玫瑰花吗？");
    if(con==true)
        alert("非常喜欢!");
    else alert("不喜欢!");
}

function LLPrompt(){
    var name=prompt("请问你叫什么名字?");
    alert(name);
}

//js交互方式一
function firstClick() {
    LoadUrl("app://shareClick?title=分享的标题&content=分享的内容&url=链接地址&imagePath=图片地址");
}

function LoadUrl(url){
    var iFrame;
    iFrame = document.createElement("iframe");
    iFrame.setAttribute("src", url);
    iFrame.setAttribute("style", "display:none");
    iFrame.setAttribute("height", "0px");
    iFrame.setAttribute("width", "0px");
    iFrame.setAttribute("frameborder", "0");
    document.body.appendChild(iFrame);
    iFrame.parentNode.removeChild(iFrame);
    iFrame = null;
}

//js交互方式二
function secondClick() {
    LLAlert("王照猛");
}

//自定义
function asyncAlert(content) {
setTimeout(function(){
           alert(content);
           },1);
}
