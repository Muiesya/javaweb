package com.example.servlet;

import com.example.dao.MedicineDAO;
import com.example.model.Medicine;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "MedicineExportServlet", urlPatterns = "/medicine/export")
public class MedicineExportServlet extends HttpServlet {
    private final MedicineDAO medicineDAO = new MedicineDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        List<Medicine> list;
        try {
            list = medicineDAO.search(keyword);
        } catch (SQLException e) {
            getServletContext().log("导出药材失败", e);
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "导出失败：" + e.getMessage());
            return;
        }

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("药材信息");
            createHeader(sheet);
            for (int i = 0; i < list.size(); i++) {
                Medicine m = list.get(i);
                Row row = sheet.createRow(i + 1);
                row.createCell(0).setCellValue(m.getCode());
                row.createCell(1).setCellValue(m.getName());
                row.createCell(2).setCellValue(m.getAlias());
                row.createCell(3).setCellValue(m.getPrice());
                row.createCell(4).setCellValue(m.getStock());
                row.createCell(5).setCellValue(m.getGrowthEnvironment());
                row.createCell(6).setCellValue(m.getMainFunction());
            }

            resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            String filename = URLEncoder.encode("medicines.xlsx", StandardCharsets.UTF_8.name()).replace("+", "%20");
            resp.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + filename);
            workbook.write(resp.getOutputStream());
        }
    }

    private void createHeader(Sheet sheet) {
        Row header = sheet.createRow(0);
        String[] titles = {"编号", "名称", "别名", "单价", "库存", "生长环境", "功效"};
        for (int i = 0; i < titles.length; i++) {
            Cell cell = header.createCell(i);
            cell.setCellValue(titles[i]);
        }
    }
}
