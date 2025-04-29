class Test {
  final int coso;

  Test({required this.coso});

  factory Test.fromJson(Map<String, dynamic> j) => Test(coso: j["coso"]);

  Map<String, dynamic> toJson() => {
        "coso": coso,
      };
}
