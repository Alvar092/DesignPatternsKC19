// Mapeamos el DTO que nos llegará en JSON al objeto HeroModel
final class HeroDTOToHeroModelMapper {
    func map(_ dto: HeroDTO) -> HeroModel {
        HeroModel(identifier: dto.identifier,
                  name: dto.name,
                  description: dto.description,
                  photo: dto.photo,
                  favorite: dto.favorite)
    }
}
