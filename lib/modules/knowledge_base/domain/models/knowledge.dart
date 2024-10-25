class Knowledge {
  String name;
  String description;
  DateTime updatedTime;
  List<Unit> units = [];
  Knowledge(this.name, this.description, this.updatedTime, this.units);

  int getSize() {
    int size = 0;
    for (var unit in units) {
      size += unit.getSize();
    }
    return size;
  }

  //add unit
  void addUnit(Unit unit) {
    units.add(unit);
  }

  void removeUnit(Unit unit) {
    units.remove(unit);
  }
}

abstract class Unit {
  String name;
  String source;
  DateTime updatedTime;
  bool enabled;
  Unit(this.name, this.source, this.updatedTime, this.enabled);
  String getServiceName();
  int getSize() {
    return 0;
  }
}

class LocalFile extends Unit {
  String path;
  LocalFile(
      super.name, super.source, super.updatedTime, super.enabled, this.path);
  @override
  String getServiceName() {
    return 'Local File';
  }
}

class Website extends Unit {
  String url;
  Website(super.name, super.source, super.updatedTime, super.enabled, this.url);
  @override
  String getServiceName() {
    return 'Website';
  }
}

class Github extends Unit {
  String url;
  Github(super.name, super.source, super.updatedTime, super.enabled, this.url);
  @override
  String getServiceName() {
    return 'Github Repository';
  }
}

class GoogleDrive extends Unit {
  String url;
  GoogleDrive(
      super.name, super.source, super.updatedTime, super.enabled, this.url);
  @override
  String getServiceName() {
    return 'Google Drive';
  }
}

class Slack extends Unit {
  String url;
  Slack(super.name, super.source, super.updatedTime, super.enabled, this.url);
  @override
  String getServiceName() {
    return 'Slack';
  }
}

class Confluence extends Unit {
  String url;
  Confluence(
      super.name, super.source, super.updatedTime, super.enabled, this.url);
  @override
  String getServiceName() {
    return 'Confluence';
  }
}
