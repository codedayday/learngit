<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fn" uri="/WEB-INF/tld/fn.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%@ taglib prefix="duxiu" uri="/WEB-INF/tld/duxiu.tld"%>
<!doctype html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1, user-scalable=no" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>超星发现系统</title>
<link href="/style/discover/common.css" rel="stylesheet" type="text/css"/>
<link href="/style/discover/style2.css" rel="stylesheet" type="text/css"/>
<link href="/style/discover/mobilespecial.css" rel="stylesheet" type="text/css"/>
<link href="/images/discover/newcxdiscover/fx2.ico" rel="SHORTCUT ICON" />
<script src="/js/jquery-1.8.3.min.js"></script>
<style>
html,body{height:100%;}
</style>
</head>

<body>
<form id="searchform" action="searchspecial" method="get">
	<input type="hidden" id="specialchannel" name="specialchannel" value="special">
	<input type="hidden" id="cataid" name="cataid" value="${viewdata.paramsmap['cataid'] }">
	<input type="hidden" id="specialids" name="specialids" value="${viewdata.paramsmap['specialids'] }">
</form>
	<c:set var="domaininfo" value="${viewdata.collectors.domaininfos[0] }"/>
	<c:set var="name_count" value="${fn:split(domaininfo['name'], ' by ') }"/>
	<div class="header_pos" style="background-color: #f1f5f7;padding-top: 6px; line-height: 40px; height: auto; overflow: hidden;">
		<h2 style="margin-left: 8px; display: inline;">${name_count[0] }</h2>
		<h4 style="display: inline;">(${domaininfo['count'] })</h4>
		<c:if test="${!empty cata }">
		<p class="fr zti_off"></p>
		</c:if>
	</div>
	<div style="display:none;">
	<c:set var="sCount" value=""></c:set>
	<c:forEach items="${cata }" var="catabean1">
	<c:if test="${viewdata.paramsmap['cataid'] == catabean1.id}">
		<c:set var="sCount" value="${name_count[0] }>>${catabean1.name }"></c:set>
	</c:if>
	<div class="ztitle">
		<h2 class="fl zti_h" id="${catabean1.id }">${catabean1.name }(${catabean1.count })</h2>
		<c:if test="${!empty catabean1.children }">
		<p class="fr zti_off"></p>
		</c:if>
		<div class="clear"></div>
	</div>
	<div class="zlist" style="display: none;">
	<c:forEach items="${catabean1.children }" var="catabean2">
		<c:if test="${viewdata.paramsmap['cataid'] == catabean2.id}">
			<c:set var="sCount" value="${name_count[0] }>>${catabean1.name }>>${catabean2.name }"></c:set>
		</c:if>
		<p class="zli_item"><a id="${catabean2.id }" href="/searchspecial?specialchannel=special&cataid=${catabean2.id }&specialids=${viewdata.paramsmap['specialids'] }" target="_self">${catabean2.name }</a></p>
	</c:forEach>
	</div>
	</c:forEach>
	<input type="hidden" value="${sCount }" id="sCount"/>
	</div>
    <div class="resultList">
        <ul>
        	<c:if test="${viewdata.count > 0 }">
        		<c:set var="oridata" value="${viewdata.datas }"></c:set>
        		<c:forEach items="${oridata  }" var="datas" varStatus="status">
        			<li class="liresults">
		                <a href="${datas.infos['url'] }">
		                    <dl class="img_r">
		                        <dt style="color: #333;line-height: 20px;">
		                        	<h3 style="display: inline;">${datas.infos['C301'] }</h3>
		                        </dt>
		                        <dd style="font-size: 14px;color: #999;">${datas.infos['formatinfo'] }</dd>
		                    </dl>
		                </a>
		            </li>
        		</c:forEach>
        	</c:if>
        </ul>
    </div>
    <jsp:include page="../mobile/footer.jsp"></jsp:include>
    <!--筛选 begin-->
    <!--筛选 end-->
<input type="hidden" value="2" id="loctionpages"/>
<input type="hidden" value="2" id="pagenums"/>
<script type="text/javascript">
var isload = false;
window.onscroll=function(){
	var a = document.documentElement.scrollTop==0? document.body.clientHeight : document.documentElement.clientHeight;
	if(a>document.documentElement.clientHeight){
		a=document.documentElement.clientHeight;
	}
	var b = document.documentElement.scrollTop==0? document.body.scrollTop : document.documentElement.scrollTop;
	var c = document.documentElement.scrollTop==0? document.body.scrollHeight : document.documentElement.scrollHeight;
	if((a+b)>(c-100) && !isload){
		isload = true;
		getMore();
	}
};
function getMore(){
	var url = window.location.href;
	var urlArray = url.split("?");
	var uri = urlArray[1];
	var searchurl = url;
	searchurl = changeUrlField(searchurl,"json" , "json");
	var pages = parseInt($("#loctionpages").val());
	var pagenums = parseInt($("#pagenums").val());
	if(pages > pagenums) return false;
	searchurl = changeUrlField(searchurl,"pages",pages);
	if(searchurl != ""){
		$.ajax({
			url: searchurl,
			dataType: "json",
			cache: false,
			beforeSend: function () {
				$("#moredataid").show();
				$("#nodataid").hide();
		    },
			success: function(data){
				searchurl = "";
				if(data.list && data.list.length>0){
					$.each(data.list,function(i,v){
						$(".liresults:last").after("<li class='liresults'>"+
														"<a href='"+v.infos['url']+"'>"+
															"<dl class='img_r'>"+
// 																"<dt style='color: #333;line-height: 20px;'><h3>"+v.infos['C301']+ "["+v.infos['fl']+"]"+"</h3></dt>"+
																"<dt style='color: #333;line-height: 20px;'><h3>"+v.infos['C301']+"</h3></dt>"+
																"<dd style='font-size: 14px;color: #999;'>"+(v.infos['formatinfo']||"")+"</dd>"+
															"</dl>"+
														"</a>"+
													"</li>");
					});
					$("#loctionpages").val(data.pages);
					$("#pagenums").val(data.pagenums);
					isload = false;
					if(data.list.length<10){//返回数量不足10条，证明已经没有多余数据
						$("#moredataid").hide();
						$("#nodataid").show();
					}else{//大于等于10条，证明还有数据
						havescroll();
					}
				}else{
					$("#moredataid").hide();
					$("#nodataid").show();
				}
			},
			complete: function () {
				$("#moredataid").hide();
		    },
		    error: function (data) {
		    	$("#moredataid").hide();
		    }
		});
	}
}
function changeUrlField(url, arg, arg_val) {
    var pattern = arg + '=([^&]*)';
    var replaceText = arg + '=' + arg_val;
    if (url.match(pattern)) {
        var tmp = '/(' + arg + '=)([^&]*)/gi';
        tmp = url.replace(eval(tmp), replaceText);
        return tmp;
    } else {
        if (url.match('[\?]')) {
            return url + '&' + replaceText;
        } else {
            return url + '?' + replaceText;
        }
    }
    return url + '\n' + arg + '\n' + arg_val;
}
function changeChannelSort(changeChannelId, e){
	$(e).css({"background-color":"#999"}).html('已订阅');
}
function havescroll(){
	if((document.body.style.overflow != "hidden") && (document.body.scroll != "no") && (document.body.scrollHeight > document.body.offsetHeight)){
		//有滚动条
	}else { 
		//没滚动条加载数据
		getMore();
	}
}
havescroll();//执行判断页面是否有滚动条，没滚动条证明页面没填充满，继续加载数据
$(function() {
	$(".ztitle, .header_pos").on('click', function(event) {
		var oTarget = event.target;
		
		if($(oTarget).is(".zli_item") || $(oTarget).is(".zti_h") || $(oTarget).parent().is(".zli_item")){
			var oSearchform = $("#searchform");
			oSearchform.find("#cataid").val($(oTarget).attr("id"));
			oSearchform.submit();
		} else {
			if(!$(oTarget).is(".zti_off")){
				if(!$(oTarget).is(".ztitle") && !$(oTarget).is(".header_pos")){
					oTarget = $(oTarget).parent();
				}
				oTarget = $(oTarget).find(".zti_off");
			}
			if(oTarget != "undefined" ){
				if ($(oTarget).parent().next().is(":visible")) {
					if (!($(oTarget).parent().next().is(':animated'))) {
						$(oTarget).parent().next().slideUp(200);
						$(oTarget).removeClass('zti_on');
					}
				} else {
					if (!($(oTarget).parent().next().is(':animated'))) {
						$(oTarget).parent().next().slideDown(200);
						$(oTarget).addClass('zti_on');
					}
				}
			}
		}
	});
});
(function(){
	var sCount = document.getElementById("sCount").value;
	if(sCount != ""){
		document.getElementsByClassName("header_pos")[0].getElementsByTagName("h2")[0].innerHTML = sCount;
	}
})();
</script>
</body>
</html>
