sealed class ProjectException implements Exception {}


class CreateProjectException extends ProjectException {}

class ProjectAlreadyExistsException extends ProjectException {}

class GetProjectListException extends ProjectException {}

class DeleteProjectException extends ProjectException {}