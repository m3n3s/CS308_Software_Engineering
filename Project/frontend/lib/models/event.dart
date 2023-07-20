// For testing purposes, will change in the future
class Event {
  final String id;
  final String name;
  final String thumbnail;
  final String performer;
  final String date;
  final String location;
  final String time;
  final String rules;
  final String prices;
  final String seatingPlan;
  final int totalTickets;
  final int availableTickets;

  Event({
    this.id,
    this.name,
    this.thumbnail,
    this.location,
    this.date,
    this.time,
    this.performer,
    this.rules,
    this.prices,
    this.seatingPlan,
    this.totalTickets,
    this.availableTickets,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['eventID'].toString(),
      name: json['name'],
      thumbnail: json['thumbnail'],
      performer: json["performer"],
      date: json["date"],
      location: json["location"],
      time: json["time"],
      rules: json["rules"],
      prices: json["prices"],
      seatingPlan: json["seatingPlan"],
      totalTickets: json["totalTickets"],
      availableTickets: json["availableTickets"],
    );
  }
}

List<Event> hardcodedEvents = [
  Event(
    name: "Sample event 1",
    thumbnail:
        "https://image.shutterstock.com/image-photo/rave-concert-party-edm-festival-600w-1916911232.jpg",
    date: "11.2.2021",
    location: "Istanbul1",
    time: "11.00",
    performer: "Performer1",
  ),
  Event(
    name: "Sample event 2",
    thumbnail:
        "https://image.shutterstock.com/image-photo/confetti-falling-on-festive-concert-600w-1147630022.jpg",
    date: "11.2.2021",
    location: "Istnabul2",
    time: "11.00",
    performer: "Performer2",
  ),
  Event(
    name: "Sample event 3",
    thumbnail:
        "https://image.shutterstock.com/image-photo/confetti-falling-on-festive-concert-600w-1147630022.jpg",
    date: "11.2.2021",
    location: "Istnabul3",
    time: "11.00",
    performer: "Performer3",
  ),
  Event(
    name: "Sample event 4",
    thumbnail:
        "https://image.shutterstock.com/image-photo/close-musician-hands-cello-on-600w-23285866.jpg",
    date: "11.2.2021",
    location: "Istnabul4",
    time: "11.00",
    performer: "Performer4",
  ),
  Event(
    name: "Sample event 5",
    thumbnail:
        "https://image.shutterstock.com/image-photo/piano-flute-golden-shine-sheet-600w-516401134.jpg",
    date: "11.2.2021",
    location: "Istnabul5",
    time: "11.00",
    performer: "Performer5",
  ),
];

List<Event> hardcodedFeaturedEvents = [
  Event(
    name: "featured event 1",
    thumbnail:
        "https://image.shutterstock.com/image-vector/retro-styled-jazz-festival-poster-600w-315508430.jpg",
    date: "11.2.2021",
    location: "Istanbul1",
    time: "11.00",
    performer: "Performer1",
  ),
  Event(
    name: "featured event 2",
    thumbnail:
        "https://image.shutterstock.com/image-vector/guitar-on-dirty-background-600w-25688512.jpg",
    date: "11.2.2021",
    location: "Istnabul2",
    time: "11.00",
    performer: "Performer2",
  ),
  Event(
    name: "featured event 3",
    thumbnail:
        "https://image.shutterstock.com/image-photo/nashville-tenn-february-15-2020-600w-1663421932.jpg",
    date: "11.2.2021",
    location: "Istnabul3",
    time: "11.00",
    performer: "Performer3",
  ),
  Event(
    name: "featured event 4",
    thumbnail:
        "https://image.shutterstock.com/image-photo/miami-fl-usa-march-14-600w-1935839452.jpg",
    date: "11.2.2021",
    location: "Istnabul4",
    time: "11.00",
    performer: "Performer4",
  ),
  Event(
    name: "featured event 5",
    thumbnail:
        "https://image.shutterstock.com/image-photo/hipster-igen-teen-pretty-fashion-600w-1564166668.jpg",
    date: "11.2.2021",
    location: "Istnabul5",
    time: "11.00",
    performer: "Performer5",
  ),
];
