import 'package:flutter/material.dart';
import 'package:teams/Utils/styles.dart';

class DrawerAbout extends StatelessWidget {

  String _about = 'مكتبة الإلكترونية مكتبةٌ لا تُغلَق .. مكتبةٌ لا تغيب .. وتصل لها في أي مكان و بكلّ لحظة و بالترحيب دوماً 💚 بما تحويه من محاضرات طبيّة و جلسات عمليّة و مراجع عالميّة تواكب كلّ جديد 🔥 هدفها الحفاظ على أعمال الفرق الطبية من السرقة ونشرها بطريقة تضمن الحفاظ على جهدهم وتعبهم المبذول في كوكب آمن من العلم والمعرفة مفتاحه كود بسيط يعود لتكاليف الصيانة و البرمجة و الحجز المستمرّ للموقع الإلكتروني الرسمي و الوحيد على مدار العام الدراسيّ .. ليس إلّا 💚 فقديماً كان لا غنى عن الورقةِ و القلم .. لكنّك الآن ستتمتّع بكلّ ما تريد .. بميّزات لتلوين و التحديد و الرسم بالإضافة إلى ضبط الوقت المخصص لدراستك و بالتالي  : أنتَ لستَ في مكتبة عامّة .. أنتَ هنا في حجرتك الدراسيّة الكاملة 🔥';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Positioned(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/designs/1.png'),
                          fit: BoxFit.fill
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
