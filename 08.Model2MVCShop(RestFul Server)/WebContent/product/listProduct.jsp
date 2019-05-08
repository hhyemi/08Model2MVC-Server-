<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@ page contentType="text/html; charset=EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<html>
<head>
<title>상품 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<script type="text/javascript">

	// 검색 / page 두가지 경우 모두 Form 전송을 위해 JavaScrpt 이용  

function fncGetList(currentPage) {
	document.getElementById("currentPage").value = currentPage;
   	document.detailForm.submit();		
}
	
function fncGetList2(currentPage,priceSort) {
	document.getElementById("currentPage").value = currentPage;
	document.getElementById("priceSort").value = priceSort;	
   	document.detailForm.submit();		
}

</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;">


<form name="detailForm" action="/product/listProduct?menu=${param.menu }" method="post" onsubmit="return false">
 <table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37"/>
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">
				<!-- manage랑 search 구분 -->
				<c:if test = "${param.menu eq 'manage'}">			
					상품관리
				</c:if>
				<c:if test = "${param.menu eq 'search'}">
					상품 목록 관리
				</c:if>	
					</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif" width="12" height="37"/>
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="right">
			<select name="searchCondition" class="ct_input_g" style="width:80px">
				<c:if test= "${ user.role eq 'admin'}">
				<option value="0"  ${ ! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>상품번호</option>
				</c:if>
				<option value="1"  ${ ! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>상품명</option>
				<option value="2"  ${ ! empty search.searchCondition && search.searchCondition==2 ? "selected" : "" }>상품가격</option>
			</select>
	
			<input type="text" name="searchKeyword" value="${! empty search.searchKeyword ? search.searchKeyword : ""}"   onkeypress="if(event.keyCode==13){javascript:fncGetList('1');}" class="ct_input_g" style="width:200px; height:19px" />
		</td>	
		<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						<a href="javascript:fncGetList('1');">검색</a>
					</td>
					<td width="14" height="23">
						<img src="/images/ct_btnbg03.gif" width="14" height="23">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
 
<table width="50%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;"   >
	<tr>
	<%-- 	<td align="right">
		직접 가격 입력 
		<input type="text" name="priceKeyword" value="${! empty search.priceKeyword ? search.priceKeyword : ""}" onkeypress="if(event.keyCode==13){javascript:fncGetList('1');}" class="ct_input_g" size="10"  />
		~
		<input type="text" name="priceKeyword" value="${! empty search.priceKeyword ? search.priceKeyword : ""}" onkeypress="if(event.keyCode==13){javascript:fncGetList('1');}" class="ct_input_g" size="10"  />
		</td> --%>
		<td width="17" height="23" >
				<img src="/images/ct_btnbg01.gif" width="17" height="23">
		</td>
		<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
				<a href="javascript:fncGetList('1');">검색</a>
		</td>
		<td width="14" height="23">
				<img src="/images/ct_btnbg03.gif" width="14" height="23">
		</td>
		<td align="right">
		

		<input type="hidden" id="priceSort" name="priceSort"  value=${ ! empty search.priceSort ? search.priceSort : "" } />
		<h2><a href="javascript:fncGetList2('1','high');">가격높은순</a></h2>
		</td>
		<td align="right">
		<h2><a href="javascript:fncGetList2('1','low');">가격낮은순</a></h2>
		</td>

	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">

	<tr>

	<!-- map에 저장된 값들 -->

	<td colspan="11" >
				전체  ${resultPage.totalCount } 건수, 현재 ${resultPage.currentPage}  페이지
		</td>
	</tr>

	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">상품명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">가격</td>
		<td class="ct_line02"></td>
		
		<c:if test= "${ user.role eq 'admin'}">
		<td class="ct_list_b">등록일</td>
		</c:if>
		<c:if test= "${ user.role eq 'user'  || empty user.role}">
		<td class="ct_list_b">상품상세정보</td>
		</c:if>
			
		<td class="ct_line02"></td>
		<td class="ct_list_b">
		현재상태
		<c:if test= "${ user.role eq 'admin'}">
		<select name="shippingCondition" class="ct_input_g" style="width:80px" onchange="javascript:fncGetList('1')">
				<option value="9"  ${ ! empty search.shippingCondition && search.shippingCondition==9 ? "selected" : "" }>모두보기</option>
				<option value="0"  ${ ! empty search.shippingCondition && search.shippingCondition==0 ? "selected" : "" }>판매중</option>
				<option value="1"  ${ ! empty search.shippingCondition && search.shippingCondition==1 ? "selected" : "" }>구매완료</option>
				<option value="2"  ${ ! empty search.shippingCondition && search.shippingCondition==2 ? "selected" : "" }>배송중</option>
				<option value="3"  ${ ! empty search.shippingCondition && search.shippingCondition==3 ? "selected" : "" }>배송완료</option>
		</select>
		</c:if>
		
		<c:if test= "${ user.role eq 'user'  || empty user.role}">
		<select name="shippingCondition" class="ct_input_g" style="width:80px" onchange="javascript:fncGetList('1')">
				<option value="9"  ${ ! empty search.shippingCondition && search.shippingCondition==9 ? "selected" : "" }>모두보기</option>
				<option value="0"  ${ ! empty search.shippingCondition && search.shippingCondition==0 ? "selected" : "" }>판매중</option>
	
		</select>
		</c:if>
		
		</td>	
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
	<!-- list에 저장된 값들  -->
	
	<c:set var="i" value="0"/>
	<c:forEach var="product" items="${list}">
		<c:set var ="i" value="${i+1}"/>
	<tr class="ct_list_pop">
		<td align="center">${ i }</td>
		<td></td>
		<td align="left">
		
		<!-- admin일때 -->
		<c:set var="code" value="${fn:substring(product.proTranCode,0,1)}"/>
		
		<c:if test= "${ user.role eq 'admin'}">		
		<c:if test="${code eq 0 }">
		<a href="/product/getProduct?prodNo=${product.prodNo}&menu=${param.menu}&tranCode=${code}">${product.prodName}</a>
		</c:if>
		<c:if test = "${!(code eq 0)}">
			<a href="/product/getProduct?prodNo=${product.prodNo}&menu=search">${product.prodName}</a>
		</c:if>
		
		<td></td>
		<td align="left">${product.price}</td>
		<td></td>
		<td align="left">${product.regDate}</td>	
		<td></td>
		
			<c:if test = "${param.menu eq 'manage'}">			
				<c:choose>
					<c:when test = "${code eq 0 }">
						<td align="left"> 판매중 </td>
					</c:when>
					<c:when test = "${code eq 1 }">
						<td align="left"> 구매완료 <a href="/purchase/updateTranCodeByProd?prodNo=${product.prodNo}&tranCode=${code+1}&currentPage=${resultPage.currentPage}">배송하기</a> </td>
					</c:when>
					<c:when test = "${code eq 2 }">
						<td align="left"> 배송중 </td>
					</c:when>
					<c:otherwise>
						<td align="left"> 배송완료 </td>
					</c:otherwise>		
				</c:choose>			
			</c:if>
			
			<c:if test ="${param.menu eq 'search'}">
				<c:choose>
					<c:when test= "${code eq 0}">
						<td align="left"> 판매중 </td>
					</c:when>
					<c:when test= "${code eq 1}">
						<td align="left"> 구매완료 </td>
					</c:when>
					<c:when test= "${code eq 2}">
						<td align="left"> 배송중 </td>
					</c:when>
					<c:otherwise>
						<td align="left"> 배송완료 </td>
					</c:otherwise>
				</c:choose>
			</c:if>
		</c:if>
		<!-- 유저일때 -->
		<c:if test= "${ user.role eq 'user' || empty user.role}">
			<c:choose>
				<c:when test="${product.proTranCode eq '0'}">
				<a href="/product/getProduct?prodNo=${product.prodNo}&menu=${param.menu}&tranCode=${code}">${product.prodName}</a>
				</c:when>
				<c:otherwise>
				${product.prodName}
				</c:otherwise>
			</c:choose>
		
		<td></td>
		<td align="left">${product.price}</td>
		<td></td>
		<td align="left">${product.prodDetail}</td>	
		<td></td>
			
			<c:choose>
				<c:when test ="${product.proTranCode eq '0' }">
					<td align="left">판매중</td>
				</c:when>
				<c:otherwise>
					<td align="left"> 재고없음 </td>
				</c:otherwise>
			</c:choose>
		
		</c:if>
		
	</tr>
	<tr>
		<td colspan="11" bgcolor="D6D7D6" height="1"></td>
	</tr>
	</c:forEach>

</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="center">
		<!-- 맨아래 선택하는 페이지  (((총 데이터 수 나누기 getPageUnit ( 페이지 몇개나타낼건지 )))))-->
		 <input type="hidden" id="currentPage" name="currentPage" value=""/>
		 
		<jsp:include page="../common/pageNavigator.jsp"/>
		
		
    	</td>
	</tr>
</table>
<!--  페이지 Navigator 끝 -->

</form>

</div>
</body>
</html>
