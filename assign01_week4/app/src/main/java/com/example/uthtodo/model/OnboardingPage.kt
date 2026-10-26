package com.example.uthtodo.model

/**
 * Một trang trong luồng Onboarding.
 * Tất cả nội dung hiển thị lấy từ object này (OOP).
 */
data class OnboardingPage(
    val step: Int,
    val title: String,
    val description: String,
    val buttonText: String,
    val illustration: OnboardingIllustration,
    val isLast: Boolean = false
) {
    fun nextStep(): Int = step + 1
}
