class DonationImage {
  DonationImage(this.url);

  DonationImage.fromJson(Map<String, dynamic> json) : url = json['url'];

  final String url;

  static List<DonationImage> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((dynamic json) => DonationImage.fromJson(json)).toList();

  static List<DonationImage> fakeList() => <DonationImage>[
        DonationImage('https://picsum.photos/id/100/500/500'),
        DonationImage('https://picsum.photos/id/200/500/500'),
        DonationImage('https://picsum.photos/id/300/500/500'),
        DonationImage('https://picsum.photos/id/400/500/500'),
        DonationImage('https://picsum.photos/id/500/500/500'),
      ];
}
