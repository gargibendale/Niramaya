import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class YouTubeScreen extends StatelessWidget {
  final Map<String, List<Map<String, String>>> exercises = {
    'Gentle Yoga for Mental Health': [
      {
        'title':
            '30 Minute Relaxing Yoga For Mental Health | All Levels - Slow Seated Flow by Jessica Richburg',
        'url': 'http://www.youtube.com/watch?v=COp7BR_Dvps',
      },
      {
        'title': '10 Minute Yoga Stress and Anxiety by Yoga With Bird',
        'url': 'http://www.youtube.com/watch?v=8TuRYV71Rgo',
      },
      {
        'title':
            '45 min Lazy Yin Yoga for Energy Depletion, Burnout and Mental Health by Yoga with Kassandra',
        'url': 'http://www.youtube.com/watch?v=nwBcidD3xvY',
      },
      {
        'title':
            '20 min Yoga For Stress Relief | Mental Health | For Everyone by Akshaya Agnes',
        'url': 'http://www.youtube.com/watch?v=TGdNZTl86Qs',
      },
      {
        'title':
            'Yoga For Panic And Anxiety | 15 Minute Yoga Practice by Yoga With Adriene',
        'url': 'http://www.youtube.com/watch?v=8Lg4EzektCw',
      },
    ],
    'Anxiety relief exercises': [
      {
        'title':
            'Relieve Stress & Anxiety with Simple Breathing Techniques by AskDoctorJo',
        'url': 'http://www.youtube.com/watch?v=odADwWzHR24',
      },
      {
        'title':
            '10 Minute Stress Relief Exercises - Pilates Workout for Stress and Anxiety by Jessica Valant Pilates',
        'url': 'http://www.youtube.com/watch?v=tYddPTEfS_8',
      },
      {
        'title':
            'Quick Stress Release: Anxiety Reduction Technique: Anxiety Skills #19 by Therapy in a Nutshell',
        'url': 'http://www.youtube.com/watch?v=lrhPTqholcc',
      },
      {
        'title': 'Calm your anxiety in 2 minutes! by Rachel Richards Massage',
        'url': 'http://www.youtube.com/watch?v=5zhnLG3GW-8',
      },
      {
        'title':
            'ANXIETY RELIEF Exercises | 10 Minute Daily Routines by Brain Education TV',
        'url': 'http://www.youtube.com/watch?v=iX6qn9fuxY4',
      },
    ],
    'Mindful meditation for beginners': [
      {
        'title': '10-Minute Meditation For Beginners by Goodful',
        'url': 'http://www.youtube.com/watch?v=U9YKY7fdwyg',
      },
      {
        'title':
            'Mindfulness of Thoughts to Reduce Stress and Anxiety | Beginner Meditation Series | Mindful Movement by The Mindful Movement',
        'url': 'http://www.youtube.com/watch?v=tdNgQJIs-Lk',
      },
      {
        'title':
            'Simple 5-Minute Guided Meditation For Beginners by Green Mountain at Fox Run',
        'url': 'http://www.youtube.com/watch?v=Q-L2ZKYMsag',
      },
      {
        'title': 'Mindfulness for Beginners by Doug\'s Dharma',
        'url': 'http://www.youtube.com/watch?v=ZaeQHE1oSSw',
      },
      {
        'title': '5 Minute Mindfulness Meditation by Great Meditation',
        'url': 'http://www.youtube.com/watch?v=ssss7V1_eyA',
      },
    ],
  };

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Exercises'),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: exercises.keys.length,
          itemBuilder: (context, index) {
            String category = exercises.keys.elementAt(index);
            List<Map<String, String>> videos = exercises[category]!;
            return ExpansionTile(
              title: Text(
                category,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              children: videos.map((video) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: InkWell(
                    onTap: () => _launchUrl(video['url']!),
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              video['title']!,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
