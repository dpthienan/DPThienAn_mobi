package com.example.uthtodo.ui.screens

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.uthtodo.data.AppDataProvider
import com.example.uthtodo.ui.components.AppLogoHeader
import com.example.uthtodo.ui.components.OnboardingIllustrationView
import com.example.uthtodo.ui.components.PageIndicator
import com.example.uthtodo.ui.components.PrimaryButton
import com.example.uthtodo.ui.theme.TextPrimary
import com.example.uthtodo.ui.theme.TextSecondary

@Composable
fun OnboardingScreen(
    onSkip: () -> Unit,
    onFinished: () -> Unit
) {
    val pages = AppDataProvider.onboardingPages
    val appInfo = AppDataProvider.appInfo
    var currentPage by remember { mutableIntStateOf(0) }
    val page = AppDataProvider.pageAt(currentPage)

    Column(
        modifier = Modifier
            .fillMaxSize()
            .statusBarsPadding()
            .padding(horizontal = 24.dp)
            .padding(bottom = 40.dp),
        horizontalAlignment = Alignment.Start
    ) {
        // Header: logo + bỏ qua
        AppLogoHeader(
            appName = appInfo.name,
            onSkip = onSkip
        )

        Spacer(modifier = Modifier.height(20.dp))

        // Illustration — chiếm phần lớn phía trên
        OnboardingIllustrationView(
            type = page.illustration,
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(40.dp))

        // Title — căn trái, chữ lớn
        Text(
            text = page.title,
            fontSize = 26.sp,
            fontWeight = FontWeight.Bold,
            color = TextPrimary,
            textAlign = TextAlign.Start,
            lineHeight = 34.sp,
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(12.dp))

        // Description — căn trái
        Text(
            text = page.description,
            fontSize = 15.sp,
            color = TextSecondary,
            textAlign = TextAlign.Start,
            lineHeight = 23.sp,
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(28.dp))

        // Page dots — ngay dưới description
        PageIndicator(
            pageCount = pages.size,
            currentPage = currentPage
        )

        Spacer(modifier = Modifier.weight(1f))

        // Nút hành động — sát đáy
        PrimaryButton(
            text = page.buttonText,
            onClick = {
                if (page.isLast) {
                    onFinished()
                } else {
                    currentPage = page.nextStep()
                }
            }
        )
    }
}
