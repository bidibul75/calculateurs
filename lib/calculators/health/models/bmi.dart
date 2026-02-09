const String LANG = "francais";

void main() {
  Bmi bmi = Bmi(106, 1.75, 0.0, "");
  print(bmi.bmi);
  print(bmi.bmiRange);
}

class Bmi {
  Map <String, Map<String, String>> messagesBMI = {
    "english": {
      "undernutrition": "undernutrition",
      "underweight": "underweight",
      "normal weight": "normal weight",
      "overweight": "overweight",
      "Moderate obesity": "Moderate obesity (Class I)",
      "severe obesity": "severe obesity (Class II)",
      "morbid obesity": "Morbid obesity (Class III)",
    },
    "francais": {
      "undernutrition": "dénutrition",
      "underweight": "maigreur",
      "normal weight": "poids normal",
      "overweight": "surpoids",
      "moderate obesity": "obésité modérée (Class I)",
      "severe obesity": "obésité sévère (Class II)",
      "morbid obesity": "obésité morbide (Class III)",
    },
  };

  // height in meters
  int mass;
  double height, bmi;
  String? bmiRange;

  Bmi(this.mass, this.height, this.bmi, this.bmiRange) {
    bmi = mass / (height * height);
    switch (bmi) {
      case < 16.5:
        bmiRange = messagesBMI[LANG]!["undernutrition"];
        break;
      case < 18.5:
        bmiRange = messagesBMI[LANG]!["underweight"];
        break;
      case < 25:
        bmiRange = messagesBMI[LANG]!["normal weigh"];
        break;
      case < 30:
        bmiRange = messagesBMI[LANG]!["overweight"];
        break;
      case < 35:
        bmiRange = messagesBMI[LANG]!["moderate obesity"];
        break;
      case < 40:
        bmiRange = messagesBMI[LANG]!["severe obesity"];
        break;
      default:
        bmiRange = messagesBMI[LANG]!["morbid obesity"];
    }
  }
}
