package com.example.uthtodo.data

import com.example.uthtodo.model.AppInfo
import com.example.uthtodo.model.OnboardingIllustration
import com.example.uthtodo.model.OnboardingPage
import com.example.uthtodo.model.Task
import com.example.uthtodo.model.TaskCategory

/**
 * Nguồn dữ liệu OOP cho toàn bộ app.
 * UI chỉ đọc từ đây, không tự hard-code chuỗi nội dung.
 */
object AppDataProvider {

    val appInfo: AppInfo = AppInfo(
        name = "UTH Todo",
        tagline = "Việc học, việc nhà – gọn gàng mỗi ngày",
        version = "2.1.0"
    )

    val onboardingPages: List<OnboardingPage> = listOf(
        OnboardingPage(
            step = 0,
            title = "Mọi việc, gọn trong một chỗ",
            description = "Ghi lại bài tập, việc nhà, lịch hẹn. Không còn quên việc nào.",
            buttonText = "Tiếp tục",
            illustration = OnboardingIllustration.CHECKLIST
        ),
        OnboardingPage(
            step = 1,
            title = "Chia theo Học tập và Cuộc sống",
            description = "Mỗi việc có nhóm riêng, nhìn là biết hôm nay cần lo gì.",
            buttonText = "Tiếp tục",
            illustration = OnboardingIllustration.CATEGORIES
        ),
        OnboardingPage(
            step = 2,
            title = "Nhắc đúng lúc",
            description = "Bật thông báo để UTH Todo nhắc bạn trước hạn chót.",
            buttonText = "Bắt đầu ngay",
            illustration = OnboardingIllustration.REMINDER,
            isLast = true
        )
    )

    fun pageAt(index: Int): OnboardingPage =
        onboardingPages.getOrElse(index) { onboardingPages.last() }

    fun pageCount(): Int = onboardingPages.size

    val sampleTasks: List<Task> = listOf(
        Task(1, "Ôn bài Toán", TaskCategory.STUDY, "19:00"),
        Task(2, "Nộp báo cáo CNTT", TaskCategory.STUDY, "23:59"),
        Task(3, "Đi siêu thị", TaskCategory.LIFE, "17:30"),
        Task(4, "Giặt đồ", TaskCategory.LIFE, isCompleted = true)
    )
}
