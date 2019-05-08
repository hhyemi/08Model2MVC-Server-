package com.model2.mvc.web.purchase;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.product.ProductService;
import com.model2.mvc.service.purchase.PurchaseService;

//==> 회원관리 Controller
@Controller
@RequestMapping("/purchase/*")
public class PurchaseController {

	/// Field
	@Autowired
	@Qualifier("purchaseServiceImpl")
	private PurchaseService purchaseService;

	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	// setter Method 구현 않음

	public PurchaseController() {
		System.out.println(this.getClass());
	}

	// ==> classpath:config/common.properties , classpath:config/commonservice.xml
	// 참조 할것
	// ==> 아래의 두개를 주석을 풀어 의미를 확인 할것
	@Value("#{commonProperties['pageUnit']}")
	// @Value("#{commonProperties['pageUnit'] ?: 3}")
	int pageUnit;

	@Value("#{commonProperties['pageSize']}")
	// @Value("#{commonProperties['pageSize'] ?: 2}")
	int pageSize;

	@RequestMapping(value="addPurchase",method=RequestMethod.GET)
	public String addPurchase(@RequestParam("prod_no") int prodNo, HttpSession session, Model model)
			throws Exception {

		System.out.println("/purchase/addPurchase : GET");

		User user = (User) session.getAttribute("user");

		Product product = productService.getProduct(prodNo);

		Purchase purchase = new Purchase();

		purchase.setBuyer(user);
		purchase.setPurchaseProd(product);

		model.addAttribute("purchase", purchase);

		return "forward:/purchase/addPurchaseView.jsp";
	}

	@RequestMapping(value="addPurchase",method=RequestMethod.POST)
	public String addPurchase(@ModelAttribute("purchase") Purchase purchase, @RequestParam("prodNo") int prodNo,
			HttpSession session) throws Exception {

		System.out.println("/purchase/addPurchase : POST");

		User user = (User) session.getAttribute("user");
		Product product = productService.getProduct(prodNo);
		purchase.setBuyer(user);
		purchase.setPurchaseProd(product);

		purchaseService.addPurchase(purchase);

		return "forward:/purchase/addPurchase.jsp";
	}

	@RequestMapping(value = "getPurchase", method = RequestMethod.GET)
	public String getPurchase(@RequestParam("tranNo") int tranNo, Model model) throws Exception {

		System.out.println("/purchase/getPurchase : GET");
		Purchase purchase = purchaseService.getPurchase(tranNo);

		model.addAttribute("purchase", purchase);

		return "forward:/purchase/getPurchase.jsp";
	}

	@RequestMapping(value="listPurchase")
	public String listPurchase(@ModelAttribute("search") Search search, Model model, HttpSession session)
			throws Exception {

		System.out.println("/purchase/listPurchase : GET / POST");

		if (search.getCurrentPage() == 0) {
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);

		User user = (User) session.getAttribute("user");

		Map<String, Object> map = purchaseService.getPurchaseList(search, user.getUserId());

		Page resultPage = new Page(search.getCurrentPage(), ((Integer) map.get("totalCount")).intValue(), pageUnit,
				pageSize);
		System.out.println(resultPage);

		// Model 과 View 연결
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);

		return "forward:/purchase/listPurchase.jsp";
	}

	@RequestMapping(value="updatePurchase",method=RequestMethod.GET)
	public String updatePurchase(@RequestParam("tranNo") int tranNo, Model model) throws Exception {

		System.out.println("/purchase/updatePurchase : GET");
		// Business Logic
		Purchase purchase = purchaseService.getPurchase(tranNo);

		// Model 과 View 연결
		model.addAttribute("purchase", purchase);
		return "forward:/purchase/updatePurchaseView.jsp";
	}

	@RequestMapping(value="updatePurchase",method=RequestMethod.POST)
	public String updatePurchase(@ModelAttribute("purchase") Purchase purchase, @RequestParam("tranNo") int tranNo,
			Model model) throws Exception {

		System.out.println("/purchase/updatePurchase : POST");
		purchaseService.updatePurchase(purchase);

		return "redirect:/purchase/getPurchase?tranNo=" + tranNo;
	}

	@RequestMapping(value="updateTranCode")
	public String updateTranCode(@ModelAttribute("purchase") Purchase purchase, @ModelAttribute("search") Search search,
			@RequestParam("tranNo") int tranNo, @RequestParam("tranCode") String tranCode, Model model,
			HttpSession session) throws Exception {

		if (search.getCurrentPage() == 0) {
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);

		System.out.println("/purchase/updateTranCode");

		purchase = purchaseService.getPurchase(tranNo);
		purchase.setTranCode(tranCode);
		purchaseService.updateTranCode(purchase);

		User user = (User) session.getAttribute("user");

		Map<String, Object> map = purchaseService.getPurchaseList(search, user.getUserId());

		Page resultPage = new Page(search.getCurrentPage(), ((Integer) map.get("totalCount")).intValue(), pageUnit,
				pageSize);
		System.out.println(resultPage);

		// Model 과 View 연결
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);

		return "forward:/purchase/listPurchase.jsp";

	}

	@RequestMapping(value="updateTranCodeByProd")
	public String updateTranCodeByProd(@ModelAttribute("purchase") Purchase purchase,
			@ModelAttribute("search") Search search, @RequestParam("prodNo") int prodNo,
			@RequestParam("tranCode") String tranCode, Model model, HttpSession session) throws Exception {

		if (search.getCurrentPage() == 0) {
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);
		search.setPriceSort("all");
		
		System.out.println("/purchase/updateTranCodeByProd");

		purchase = purchaseService.getPurchase2(prodNo);
		purchase.setTranCode(tranCode);
		purchaseService.updateTranCode(purchase);

		User user = (User) session.getAttribute("user");

		Map<String, Object> map = purchaseService.getPurchaseList(search, user.getUserId());

		Page resultPage = new Page(search.getCurrentPage(), ((Integer) map.get("totalCount")).intValue(), pageUnit,
				pageSize);
		System.out.println(resultPage);


		// Model 과 View 연결
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);

		return "forward:/product/listProduct?menu=manage";
	}
	
	@RequestMapping(value="deletePurchase")
	public String deletePurchase(@ModelAttribute("purchase") Purchase purchase,
			@ModelAttribute("search") Search search, @RequestParam("tranNo") int tranNo,
			 Model model, HttpSession session) throws Exception {

		if (search.getCurrentPage() == 0) {
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);
		
		System.out.println("/purchase/deletePurchase");

		purchaseService.deletePurchase(tranNo);

		User user = (User) session.getAttribute("user");

		Map<String, Object> map = purchaseService.getPurchaseList(search, user.getUserId());

		Page resultPage = new Page(search.getCurrentPage(), ((Integer) map.get("totalCount")).intValue(), pageUnit,
				pageSize);
		System.out.println(resultPage);

		// Model 과 View 연결
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);

		return "forward:/purchase/listPurchase.jsp";
	}

}