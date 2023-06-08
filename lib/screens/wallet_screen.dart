import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_transaction_screen.dart';
import '/constants/app_textstyle.dart';
import '/constants/color_constants.dart';
import 'package:fl_chart/fl_chart.dart';

class WalletScreen extends StatelessWidget {
  final String id;

  const WalletScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = FirebaseFirestore.instance.collection('users');
    final userDoc = users.doc(id);
    final transactions = userDoc.collection('transactions');

    List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text('Wallet', style: ApptextStyle.MY_CARD_TITLE),
        backgroundColor: kPrimaryColor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userDoc.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong', style: ApptextStyle.BODY_TEXT));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: kPrimaryColor));
          }

          Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
          String totalBalance = userData.containsKey('totalBalance') ? userData['totalBalance'] : '0';

          return Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: StreamBuilder<QuerySnapshot>(
                  stream: transactions.snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Something went wrong', style: ApptextStyle.BODY_TEXT));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: kPrimaryColor));
                    }

                    List<FlSpot> data = snapshot.data!.docs.asMap().entries.map((entry) {
                      int idx = entry.key;
                      DocumentSnapshot document = entry.value;
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      return FlSpot(idx.toDouble(), double.parse(data['currentBalance']));
                    }).toList();

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: const Color(0xff37434d),
                                strokeWidth: 1,
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: const Color(0xff37434d),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 22,
                              getTextStyles: (context, value) => const TextStyle(
                                color: Color(0xff68737d),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              getTitles: (value) {
                                return value.toInt().toString();
                              },
                              margin: 8,
                            ),
                            leftTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (context, value) => const TextStyle(
                                color: Color(0xff67727d),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              getTitles: (value) {
                                return value.toInt().toString();
                              },
                              reservedSize: 28,
                              margin: 12,
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: const Color(0xff37434d), width: 1),
                          ),
                          minX: 0,
                          maxX: (data.length - 1).toDouble(), // Adjust maxX to the number of data points
                          minY: 0,
                          maxY: data.map((spot) => spot.y).reduce((a, b) => a > b ? a : b), // Adjust maxY to the maximum y value
                          lineBarsData: [
                            LineChartBarData(
                              spots: data,
                              isCurved: true,
                              colors: gradientColors,
                              barWidth: 5,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: false,
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Text('Total Available Balance: $totalBalance', style: ApptextStyle.MY_CARD_TITLE),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: transactions.snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Something went wrong', style: ApptextStyle.BODY_TEXT));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: kPrimaryColor));
                    }

                    return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                        return ListTile(
                          title: Text(
                            data['name'],
                            style: ApptextStyle.LISTTILE_TITLE,
                          ),
                          subtitle: Text('Added Amount: ${data['currentBalance']}', style: ApptextStyle.LISTTILE_SUB_TITLE),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kSecondaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionScreen(id: id)),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
