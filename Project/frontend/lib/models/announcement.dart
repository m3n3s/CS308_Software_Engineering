class Announcement {
  final String content;
  final String date;

  Announcement({this.content, this.date});

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      content: json['content'],
      date: json['date'],
    );
  }
}

List<Announcement> hardcodedAnnouncements = [
  Announcement(
    content: "The home page is done!!!",
    date: "25.11.2021",
  ),
  Announcement(
    content:
        "It is even responsive, you can check by resizing your browser or launching a mobile emulator.",
    date: "25.11.2021",
  ),
  Announcement(
    content:
        "These are just dummy events and announcements to show on home page.",
    date: "20.11.2021",
  ),
  Announcement(
    content: "All of the events here are fakes!!!!",
    date: "22.2.2021",
  ),
  Announcement(
    content: "This is probably the last announcement.",
    date: "11.1.1111",
  ),
  Announcement(
    content: "Appearently not the last one.",
    date: "11.1.1111",
  ),
  Announcement(
    content: "Adding dummy announcement again to simulate scrolling.",
    date: "11.1.1111",
  ),
  Announcement(
    content: "This is taking a lot of time.",
    date: "11.1.1111",
  ),
  Announcement(
    content: "Still not enough.",
    date: "11.1.1111",
  ),
  Announcement(
    content: "OMG",
    date: "11.1.1111",
  ),
  Announcement(
    content: "Agaiiiiin.",
    date: "11.1.1111",
  ),
  Announcement(
    content: "This is probably the last announcement.",
    date: "11.1.1111",
  ),
  Announcement(
    content: "This is probably the last announcement.",
    date: "11.1.1111",
  ),
  Announcement(
    content: "This is probably the last announcement.",
    date: "11.1.1111",
  ),
];
