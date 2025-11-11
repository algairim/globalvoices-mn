import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,
  ) {}

  /**
   * Finds a user by their Keycloak ID (sub) or creates a new one (JIT Provisioning).
   * @param keycloakId The 'sub' claim from the Keycloak token.
   * @param username The 'preferred_username' claim.
   * @param email The 'email' claim.
   * @returns The local User entity.
   */
  async findOrCreate(keycloakId: string, username: string, email: string): Promise<User> {
    try {
      let user = await this.usersRepository.findOne({ where: { keycloakId } });

      if (!user) {
        // User not found, perform Just-In-Time Provisioning
        user = this.usersRepository.create({
          keycloakId,
          username,
          email,
          createdAt: new Date(),
        });
        await this.usersRepository.save(user);
      }
      return user;
    } catch (error) {
      console.error('Error during user findOrCreate:', error);
      // Re-throw the error as a 500 to indicate the failure reason clearly
      throw new InternalServerErrorException('Failed to provision or retrieve user from local database.');
    }
  }
}
