package com.asu.secureBankApp.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.asu.secureBankApp.dao.AccountDAO;

@Repository
public interface AccountRepository extends JpaRepository<AccountDAO, Integer> {

}
