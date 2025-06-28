package com.okstring.quotecanvas

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray

class QuoteWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.quote_widget_layout).apply {
                // 앱 실행 인텐트 설정
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)

                // 즐겨찾기 명언 데이터 가져오기
                val quotesJsonString = widgetData.getString("favorite_quotes", "[]")
                val noFavoritesMessage = widgetData.getString("no_favorites_message", "No favorite quotes yet")

                try {
                    val quotesArray = JSONArray(quotesJsonString ?: "[]")

                    if (quotesArray.length() > 0) {
                        // 시간 기반으로 명언 선택 (iOS와 동일한 로직)
                        val currentTime = System.currentTimeMillis()
                        val hour = (currentTime / (1000 * 60 * 60)) % 24
                        val day = (currentTime / (1000 * 60 * 60 * 24)) % 365
                        val seed = ((hour + day * 24) % quotesArray.length()).toInt()

                        val selectedQuote = quotesArray.getJSONObject(seed)
                        val content = selectedQuote.optString("q", "No quote available")
                        val author = selectedQuote.optString("a", "Unknown")

                        if (content.isNotEmpty() && content != "No quote available") {
                            setTextViewText(R.id.tv_quote_content, content)
                            setTextViewText(R.id.tv_quote_author, "- $author")
                        } else {
                            showNoQuotesMessage(this, noFavoritesMessage ?: "No favorite quotes yet")
                        }
                    } else {
                        showNoQuotesMessage(this, noFavoritesMessage ?: "No favorite quotes yet")
                    }
                } catch (e: Exception) {
                    showNoQuotesMessage(this, "Error loading quotes")
                }
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun showNoQuotesMessage(views: RemoteViews, message: String) {
        views.setTextViewText(R.id.tv_quote_content, message)
        views.setTextViewText(R.id.tv_quote_author, "Open Quote Canvas to add favorites")
    }
} 