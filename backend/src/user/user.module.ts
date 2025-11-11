import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { UserService } from './user.service'; // Assuming you have a user.service.ts

/**
 * This module is responsible for managing the User entity.
 * It imports TypeOrmModule.forFeature([User]) and exports it,
 * allowing any other module that imports UserModule to inject
 * the UserRepository.
 */
@Module({
  imports: [TypeOrmModule.forFeature([User])],
  providers: [UserService],
  // CRITICAL FIX: Export UserService so JwtStrategy (in AuthModule) can access it
  exports: [UserService, TypeOrmModule.forFeature([User])],
})
export class UserModule {}
