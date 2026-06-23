import 'package:cached_network_image/cached_network_image.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/configuration/app_images.dart';
import 'package:dar_plus_app/main.dart';
import 'package:dar_plus_app/utils/helpers/asset_video_helper.dart';
import 'package:dar_plus_app/utils/helpers/external_link_launcher.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AssetVideoCard extends StatelessWidget {
  final String videoUrl;

  const AssetVideoCard({super.key, required this.videoUrl});

  Future<void> _openVideo(BuildContext context) async {
    final ok = await launchExternalLink(videoUrl);
    if (!context.mounted || ok) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr.something_went_wrong)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isYoutube = isYoutubeVideoUrl(videoUrl);
    final youtubeId = isYoutube ? extractYoutubeVideoId(videoUrl) : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openVideo(context),
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black.withAlpha(12)),
            boxShadow: [
              BoxShadow(
                blurRadius: 14,
                offset: const Offset(0, 6),
                color: Colors.black.withAlpha(8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (youtubeId != null)
                        CachedNetworkImage(
                          imageUrl: youtubeThumbnailUrl(youtubeId),
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: Colors.black.withAlpha(20),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: Colors.black.withAlpha(20),
                            child: Icon(
                              Icons.play_circle_outline_rounded,
                              size: 48,
                              color: Colors.black.withAlpha(80),
                            ),
                          ),
                        )
                      else
                        Container(
                          color: Colors.black.withAlpha(20),
                          child: Icon(
                            Icons.play_circle_outline_rounded,
                            size: 48,
                            color: Colors.black.withAlpha(80),
                          ),
                        ),
                      Container(
                        color: Colors.black.withAlpha(60),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(230),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: 32,
                              color: AppColors.goldBrandColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    if (isYoutube)
                      Image.asset(
                        youtubeLogo,
                        width: 28,
                        height: 20,
                        fit: BoxFit.contain,
                      )
                    else
                      Icon(
                        Icons.videocam_rounded,
                        color: AppColors.goldBrandColor,
                        size: 22,
                      ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isYoutube ? tr.youtube : tr.watch_video,
                            style: appTextStyle(
                              context,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.black.withAlpha(230),
                            ),
                          ),
                          SizedBox(height: 0.3.h),
                          Text(
                            tr.watch_video,
                            style: appTextStyle(
                              context,
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withAlpha(110),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.open_in_new_rounded,
                      size: 18,
                      color: Colors.black.withAlpha(100),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
