package com.example.uthtodo.ui.screens

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Checklist
import androidx.compose.material3.Icon
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.uthtodo.data.AppDataProvider
import com.example.uthtodo.ui.theme.PurpleDark
import com.example.uthtodo.ui.theme.PurplePrimary
import com.example.uthtodo.ui.theme.White
import kotlinx.coroutines.delay

@Composable
fun SplashScreen(onFinished: () -> Unit) {
    val appInfo = AppDataProvider.appInfo
    var progress by remember { mutableFloatStateOf(0f) }
    val animatedProgress by animateFloatAsState(
        targetValue = progress,
        animationSpec = tween(durationMillis = 1800),
        label = "splashProgress"
    )

    LaunchedEffect(Unit) {
        progress = 1f
        delay(2200)
        onFinished()
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(PurplePrimary)
            .padding(horizontal = 32.dp, vertical = 48.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Spacer(modifier = Modifier.weight(1f))

        Box(
            modifier = Modifier
                .size(96.dp)
                .clip(RoundedCornerShape(24.dp))
                .background(White),
            contentAlignment = Alignment.Center
        ) {
            Icon(
                imageVector = Icons.Outlined.Checklist,
                contentDescription = appInfo.name,
                tint = PurplePrimary,
                modifier = Modifier.size(52.dp)
            )
        }

        Spacer(modifier = Modifier.height(28.dp))

        // "UTH" regular + "Todo" bold — matches design mockup
        Text(
            text = buildAnnotatedString {
                withStyle(
                    style = SpanStyle(
                        color = White,
                        fontSize = 32.sp,
                        fontWeight = FontWeight.Normal
                    )
                ) { append("UTH ") }
                withStyle(
                    style = SpanStyle(
                        color = White,
                        fontSize = 32.sp,
                        fontWeight = FontWeight.Bold
                    )
                ) { append("Todo") }
            }
        )

        Spacer(modifier = Modifier.height(10.dp))

        Text(
            text = appInfo.tagline,
            color = White.copy(alpha = 0.9f),
            fontSize = 15.sp,
            textAlign = TextAlign.Center,
            lineHeight = 22.sp
        )

        Spacer(modifier = Modifier.weight(1f))

        LinearProgressIndicator(
            progress = { animatedProgress },
            modifier = Modifier
                .fillMaxWidth(0.55f)
                .height(4.dp)
                .clip(RoundedCornerShape(2.dp)),
            color = White,
            trackColor = PurpleDark.copy(alpha = 0.35f),
            strokeCap = StrokeCap.Round
        )

        Spacer(modifier = Modifier.height(16.dp))

        Text(
            text = "Phiên bản ${appInfo.version}",
            color = White.copy(alpha = 0.85f),
            fontSize = 13.sp
        )
    }
}
