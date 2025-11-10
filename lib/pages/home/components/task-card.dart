import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flash_clean/@core/task/entities/task.entity.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final double alfa = 0.4;

  const TaskCard({super.key, required this.task});

  Color get shadowColor {
    if (task.expirationPercentage >= 90) {
      return Colors.redAccent;
    }

    if (task.expirationPercentage >= 80) {
      return Colors.yellowAccent;
    }

    if (task.expirationPercentage >= 40) {
      return Colors.greenAccent;
    }

    return Colors.grey[700] as Color;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: 450,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(16),
          image: task.imageUrlBackground == null
              ? null
              : DecorationImage(
                  image: AssetImage(task.imageUrlBackground as String),
                  fit: BoxFit.cover,
                ),
          boxShadow: [
            BoxShadow(blurRadius: 8, offset: Offset(0, 10), color: shadowColor),
          ],
        ),
        child: Row(
          children: [
            // Imagem da esquerda
            task.imageUrlSide == null
                ? SizedBox()
                : Container(
                    decoration: BoxDecoration(
                      // color: Colors.black.withOpacity(0.5),
                      color: Colors.black.withValues(alpha: alfa),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child: Image.asset(
                        task.imageUrlSide
                            as String, // substitua pelo seu caminho
                        // 'assets/images/wallpaper_01.jpg', // substitua pelo seu caminho
                        width: 100,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

            // Espaço do texto
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.black.withOpacity(0.5),
                  color: Colors.black.withValues(alpha: alfa),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),

                      Center(
                        child: Text(
                          task.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                        ),
                      ),

                      // SizedBox(height: 8),
                      // Center(
                      //   child: Text(
                      //     "Sempre se trata de homônimos estritos; algumas vezes uma página pode conter informações sobre o nome abreviado de uma pessoa, por exemplo, que coincide com o nome de outra; ou então sobre um determinado tema que, apesar de não ser homônimo de outro, apresenta aspectos muito distintos para serem explorados no mesmo artigo. ",
                      //     maxLines: 3,
                      //     overflow: TextOverflow.ellipsis,
                      //     style: Theme.of(
                      //       context,
                      //     ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                      //   ),
                      // ),
                      Spacer(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // OutlinedButton(
                          //   style: OutlinedButton.styleFrom(
                          //     backgroundColor: Colors.orange,
                          //     side: const BorderSide(color: Colors.white70),
                          //     foregroundColor: Colors.white,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //   ),
                          //   onPressed: () {},
                          //   child: const Text('Join now'),
                          // ),
                          Icon(Icons.access_time, color: shadowColor, size: 25),
                          Text(
                            "${task.time}",
                            style: TextStyle(
                              color: shadowColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // const Text(
                          //   'Clean',
                          //   style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
