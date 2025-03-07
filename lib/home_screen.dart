import 'package:flutter/material.dart';
import 'package:object_measure/detection_chat_screen.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional(0, -1),
                  children: [
                    Image.asset(
                      'assets/images/splash.png',
                      width: double.infinity,
                      height: 400,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Color(0x8D090F13),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.person_outline,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/profile');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(40, 60, 16, 24),
                          child: Text(
                            'Explore the measurement around the world.',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          height: 4,
                          thickness: 4,
                          indent: 140,
                          endIndent: 140,
                          color: Colors.grey[300],
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Measure & Object Detection',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://picsum.photos/seed/396/600',
                                  width: 140,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Measurement with object detection. Click on start.',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(height: 16),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[300],
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetectionChatScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Start Measure',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 310,
                          margin: EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                          ),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: _getCardColor(index),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SizedBox.shrink(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCardColor(int index) {
    switch (index) {
      case 0:
        return Colors.red[300]!;
      case 1:
        return Colors.red[200]!;
      case 2:
        return Colors.red[100]!;
      case 3:
        return Colors.brown[300]!;
      case 4:
        return Colors.grey[400]!;
      case 5:
        return Colors.grey[500]!;
      default:
        return Colors.grey;
    }
  }
}
