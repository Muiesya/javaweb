<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>中药材信息管理 (AJAX)</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 12px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f5f5f5; }
        .actions a, .actions button { margin-right: 8px; }
        #message { color: #d00; margin-top: 10px; }
    </style>
</head>
<body>
<h1>中药材信息（AJAX 管理）</h1>
<p><a href="index.jsp">返回首页</a> | <a href="medicine_edit.jsp">新增中药材</a></p>
<form id="searchForm">
    <label for="keyword">关键词（编号/名称/功能）：</label>
    <input type="text" id="keyword" name="keyword" placeholder="输入关键字搜索">
    <button type="submit">搜索</button>
</form>
<div id="message"></div>
<table>
    <thead>
    <tr>
        <th>编号</th>
        <th>中药名</th>
        <th>别名</th>
        <th>单价</th>
        <th>库存</th>
        <th>功效</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody id="medicineBody">
    <tr><td colspan="7">正在加载...</td></tr>
    </tbody>
</table>
<script>
    const ctx = '<%=request.getContextPath()%>';
    const bodyEl = document.getElementById('medicineBody');
    const messageEl = document.getElementById('message');
    const searchForm = document.getElementById('searchForm');

    function escapeHtml(text) {
        if (!text) return '';
        return text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    function loadMedicines(keyword = '') {
        messageEl.textContent = '';
        fetch(ctx + '/api/medicine?op=search&keyword=' + encodeURIComponent(keyword))
            .then(resp => resp.json())
            .then(data => {
                if (!data.success) {
                    messageEl.textContent = data.message || '加载失败';
                    bodyEl.innerHTML = '<tr><td colspan="7">无法获取数据</td></tr>';
                    return;
                }
                renderTable(data.data || []);
            })
            .catch(err => {
                console.error(err);
                messageEl.textContent = '请求出错: ' + err;
                bodyEl.innerHTML = '<tr><td colspan="7">请求失败</td></tr>';
            });
    }

    function renderTable(list) {
        if (!list.length) {
            bodyEl.innerHTML = '<tr><td colspan="7">没有匹配的记录</td></tr>';
            return;
        }
        bodyEl.innerHTML = '';
        list.forEach(item => {
            const tr = document.createElement('tr');
            tr.dataset.id = item.id;
            tr.innerHTML = `
                <td>${escapeHtml(item.code)}</td>
                <td>${escapeHtml(item.name)}</td>
                <td>${escapeHtml(item.alias)}</td>
                <td>${item.price || 0}</td>
                <td>${item.stock || 0}</td>
                <td>${escapeHtml(item.mainFunction)}</td>
                <td class="actions">
                    <a href="medicine_detail.jsp?id=${item.id}">查看详情</a>
                    <a href="medicine_edit.jsp?id=${item.id}">修改</a>
                    <button type="button" data-id="${item.id}">删除</button>
                </td>
            `;
            bodyEl.appendChild(tr);
        });
    }

    function deleteMedicine(id, row) {
        if (!confirm('确认删除该药材吗？')) return;
        fetch(ctx + '/api/medicine', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'op=delete&id=' + encodeURIComponent(id)
        })
            .then(resp => resp.json())
            .then(data => {
                if (data.success) {
                    row.remove();
                    if (!bodyEl.children.length) {
                        bodyEl.innerHTML = '<tr><td colspan="7">列表已空</td></tr>';
                    }
                } else {
                    alert(data.message || '删除失败');
                }
            })
            .catch(err => alert('删除出错: ' + err));
    }

    bodyEl.addEventListener('click', (e) => {
        if (e.target.tagName === 'BUTTON' && e.target.dataset.id) {
            const row = e.target.closest('tr');
            deleteMedicine(e.target.dataset.id, row);
        }
    });

    searchForm.addEventListener('submit', (e) => {
        e.preventDefault();
        loadMedicines(searchForm.keyword.value.trim());
    });

    loadMedicines();
</script>
</body>
</html>
