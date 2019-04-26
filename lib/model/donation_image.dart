class DonationImage {
  final String url;

  DonationImage(this.url);

  DonationImage.fake() : url = 'https://picsum.photos/id/400/500/500';

  static List<DonationImage> fakeList() {
    return [
      DonationImage('https://picsum.photos/id/100/500/500'),
      DonationImage('https://picsum.photos/id/200/500/500'),
      DonationImage('https://picsum.photos/id/300/500/500'),
      DonationImage('https://picsum.photos/id/400/500/500'),
      DonationImage('https://picsum.photos/id/500/500/500'),
    ];
  }
}