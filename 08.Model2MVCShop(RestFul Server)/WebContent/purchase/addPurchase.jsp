<%@ page contentType="text/html; charset=EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
<title>Insert title here</title>
</head>

<body>

	<form name="updatePurchase" action="/purchase/updatePurchase?tranNo=${purchase.tranNo }"
		method="post">

		다음과 같이 구매가 되었습니다.

		<table border=1>
			<tr>
				<td>물품번호</td>
				<td>${purchase.purchaseProd.prodNo}</td>
				<td></td>
			</tr>
			<tr>
				<td>구매자아이디</td>
				<td>${purchase.buyer.userId}</td>
				<td></td>
			</tr>
			<tr>
				<td>구매방법</td>

		<c:set var="code" value="${fn:substring(purchase.paymentOption,0,1)}"/>
		
		<c:if test="${code eq 1 }">
				<td>현금구매</td>
		</c:if>
		<c:if test="${code eq 2 }">
				<td>신용구매</td>
		</c:if>
				<td></td>
								
			</tr>
			<tr>
				<td>구매자이름</td>
				<td>${purchase.receiverName}</td>
				<td></td>
			</tr>
			<tr>
				<td>구매자연락처</td>
				<td>${purchase.receiverPhone}</td>
				<td></td>
			</tr>
			<tr>
				<td>구매자주소</td>
				<td>${purchase.divyAddr}</td>
				<td></td>
			</tr>
			<tr>
				<td>구매요청사항</td>
				<td>${purchase.divyRequest}</td>
				<td></td>
			</tr>
			<tr>
				<td>배송희망일자</td>
				<td>${purchase.divyDate}</td>
				<td></td>
			</tr>
		</table>
	</form>

</body>
</html>