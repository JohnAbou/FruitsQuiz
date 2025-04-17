import { Component, OnDestroy, OnInit } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { Subscription } from 'rxjs';
import { GameLogService } from '@app/services/user-game-log.service';
import { GameLog } from '@common/interfaces/user-game-log';
import { AuthenticationLogService } from '@app/services/user-authentication-log.service';
import { AuthenticationLog } from '@common/interfaces/user-authentication-log';
@Component({
  selector: 'app-history-page',
  templateUrl: './history-page.component.html',
  styleUrls: ['./history-page.component.scss'],
})
export class HistoryPageComponent implements OnInit, OnDestroy {

  displayedGameColumns: string[] = ['startDate', 'hasWon', 'hasAbandon'];
  tableDataGame: MatTableDataSource<GameLog> = new MatTableDataSource<GameLog>();

  displayedAuthColumns: string[] = ['loginTime', 'logoutTime', 'deviceType'];
  tableDataAuth: MatTableDataSource<AuthenticationLog> = new MatTableDataSource<AuthenticationLog>();

  private gameSubscription: Subscription = new Subscription();
  private authSubscription: Subscription = new Subscription();

  selectedTabIndex: number = 0;

  constructor(
    private readonly gameLogService: GameLogService,
    private readonly authLogService: AuthenticationLogService
  ) {}

  ngOnInit(): void {
    this.gameSubscription = this.gameLogService.gameLogs$.subscribe(
      (logs: GameLog[]) => (this.tableDataGame.data = logs)
    );
    this.authSubscription = this.authLogService.authLogs$.subscribe(
      (logs: AuthenticationLog[]) => (this.tableDataAuth.data = logs)
    );
    this.gameLogService.fetchGameLogs().subscribe();
    this.authLogService.fetchAuthenticationLogs().subscribe();
  }

  onTabChange(index: number): void {
    this.selectedTabIndex = index;
  }

  ngOnDestroy(): void {
    this.gameSubscription.unsubscribe();
    this.authSubscription.unsubscribe();
  }

}
